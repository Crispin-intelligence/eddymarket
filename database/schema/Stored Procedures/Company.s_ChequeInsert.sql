SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_ChequeInsert]
    @NumberIs INT,
    @DateIs DATE,
    @BankID UNIQUEIDENTIFIER,
    @FromAccountID UNIQUEIDENTIFIER,
    @ToAccountID UNIQUEIDENTIFIER,
    @CurrencyID UNIQUEIDENTIFIER,
    @ExchangeRate DECIMAL(18, 2),
    @Amount FLOAT,
    @BuildingID UNIQUEIDENTIFIER,
    @Crosscheck BIT,
    @TypeIs TINYINT,
    @ImageIs IMAGE,
    @DateDue DATE,
    @NotificationBeforeDays INT,
    @DescriptionIs NVARCHAR(MAX),
    @TransactionJV Transactions.dt_TransactionDetailShort READONLY,
    @TransactionJVDescriptionIs NVARCHAR(MAX),
    @NotificationTextAR NVARCHAR(MAX),
    @NotificationTextEN NVARCHAR(MAX),
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @IDs TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL
            );

            DECLARE @Ref BIGINT,
                    @RefJV BIGINT,
                    @TransactionID UNIQUEIDENTIFIER,
                    @Currency NVARCHAR(MAX),
                    @CurrencyTypeIs INT,
                    @return INT;

        END;

        BEGIN --Set info

            SELECT @Ref = COALESCE(MAX(o.Ref), 0) + 1
            FROM
            (
                SELECT s.Ref
                FROM Company.t_Cheque AS s
                UNION ALL
                SELECT s.Ref
                FROM Company.t_ChequeHistory AS s
            ) AS o;

            SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);

            SET @CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID);

        END;

        BEGIN --Insert

            SET @return = 0;

            INSERT INTO Company.t_Cheque
            (
                Ref,
                RefF,
                NumberIs,
                DateIs,
                BankID,
                Bank,
                FromAccountID,
                ToAccountID,
                CurrencyID,
                Currency,
                ExchangeRate,
                Amount,
                AmountF,
                AmountD,
                AmountLL,
                AmountEuro,
                AmountAR,
                AmountEN,
                BuildingID,
                Building,
                Crosscheck,
                TypeIs,
                TypeIsAR,
                TypeIsEN,
                ImageIs,
                DateDue,
                DateDueMonthly,
                DateDueYearly,
                NotificationBeforeDays,
                NotificationDate,
                NotificationStop,
                NotificationTextAR,
                NotificationTextEN,
                DescriptionIs
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (   @Ref, FORMAT(@Ref, 'n0'), @NumberIs, @DateIs, @BankID, Company.f_BankGetName(@BankID), @FromAccountID,
                @ToAccountID, @CurrencyID, @Currency, @ExchangeRate, @Amount, Currencys.f_Format(@CurrencyID, @Amount),
                @Amount / @ExchangeRate, Currencys.f_ExchangeToLL(@CurrencyID, @Amount, @Amount / @ExchangeRate),
                Currencys.f_ExchangeToEuro(@CurrencyID, @Amount, @Amount / @ExchangeRate),
                Currencys.f_ToWordAR(@Amount, @CurrencyID, 1), Currencys.f_ToWordEN(@Amount, @CurrencyID, 1),
                @BuildingID, Location.f_BuildingGetName(@BuildingID), @Crosscheck, @TypeIs, CASE @TypeIs
                                                                                                WHEN 0 THEN
                                                                                                    N'داخل'
                                                                                                ELSE
                                                                                                    N'خارج'
                                                                                            END, CASE @TypeIs
                                                                                                     WHEN 0 THEN
                                                                                                         N'Inside'
                                                                                                     ELSE
                                                                                                         N'Outside'
                                                                                                 END, @ImageIs,
                @DateDue, DATEFROMPARTS(YEAR(@DateDue), MONTH(@DateDue), 1), DATEFROMPARTS(YEAR(@DateDue), 1, 1),
                @NotificationBeforeDays, DATEADD(DAY, 0 - @NotificationBeforeDays, @DateDue), 0, @NotificationTextAR,
                @NotificationTextEN, @DescriptionIs);

            SET @ID =
            (
                SELECT TOP (1) s.ID FROM @IDs AS s ORDER BY s.ID
            );

        END;

        BEGIN --Insert event

            SET @return = -1;

            INSERT INTO Company.t_ChequeMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            VALUES
            (@UserID, @ID, @Event + N': ' + CONVERT(NVARCHAR(MAX), @Ref), 0, @ComputerIP, @Computer, @ComputerAccount);

        END;

        BEGIN --Transaction

            BEGIN --Set info

                SELECT @RefJV = ISNULL(MAX(s.Ref), 0) + 1
                FROM Transactions.t_Transaction AS s
                WHERE s.TypeIs = N'JV';

            END;

            BEGIN --Insert transaction

                SET @return = 0;

                DELETE FROM @IDs;

                INSERT INTO Transactions.t_Transaction
                (
                    Ref,
                    RefF,
                    TypeIs,
                    DateIs,
                    DateOnly,
                    DateFirstDayInMonth,
                    DateFirstDayInYear,
                    DescriptionIs,
                    AccountsNames,
                    LinkType,
                    LinkID,
                    UserID,
                    UserIs
                )
                OUTPUT Inserted.ID
                INTO @IDs
                (
                    ID
                )
                VALUES
                (@RefJV, FORMAT(@RefJV, 'n0'), N'JV', @DateIs, @DateIs,
                 DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1), DATEFROMPARTS(YEAR(@DateIs), 1, 1),
                 REPLACE(@TransactionJVDescriptionIs, N'{0}', @Ref),
                 Alls.f_FixXML(
                 (
                     SELECT DISTINCT
                            ', ' + t1.Name AS [text()]
                     FROM @TransactionJV AS t
                         LEFT JOIN Company.t_Account AS t1
                             ON t1.ID = t.AccountID
                     FOR XML PATH('')
                 )
                              ), 81, @ID, @UserID, Users.f_UserGetName(@UserID));

                SET @TransactionID =
                (
                    SELECT TOP (1) s.ID FROM @IDs AS s ORDER BY s.ID
                );

            END;

            BEGIN --Insert detail

                INSERT INTO Transactions.t_TransactionDetail
                (
                    RowNumber,
                    TransactionID,
                    AccountID,
                    Account,
                    DateIs,
                    DateOnly,
                    DateFirstDayInMonth,
                    DateFirstDayInYear,
                    Balance,
                    BalanceF,
                    BalanceD,
                    BalanceLL,
                    BalanceEuro,
                    BalanceAR,
                    BalanceEN,
                    Credit,
                    CreditD,
                    CreditLL,
                    CreditEuro,
                    Debit,
                    DebitD,
                    DebitLL,
                    DebitEuro,
                    StatementIs,
                    CurrencyID,
                    Currency,
                    CurrencyTypeIs,
                    ExchangeRate,
                    TypeIs,
                    ChequeNumber,
                    ChequeImage,
                    ChequeNote,
                    ChequeDateGet,
                    NotificationTextAR,
                    NotificationTextEN
                )
                SELECT o.RowNumber,
                       @TransactionID,
                       o.AccountID,
                       o.Account,
                       @DateIs,
                       @DateIs,
                       DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1),
                       DATEFROMPARTS(YEAR(@DateIs), 1, 1),
                       o.Balance,
                       o.BalanceF,
                       o.BalanceD,
                       o.BalanceLL,
                       o.BalanceEuro,
                       o.BalanceAR,
                       o.BalanceEN,
                       ABS(o.Credit),
                       ABS(IIF(o.BalanceD < 0, o.BalanceD, 0)),
                       ABS(IIF(o.BalanceLL < 0, o.BalanceLL, 0)),
                       ABS(IIF(o.BalanceEuro < 0, o.BalanceEuro, 0)),
                       o.Debit,
                       IIF(o.BalanceD > 0, o.BalanceD, 0),
                       IIF(o.BalanceLL > 0, o.BalanceLL, 0),
                       IIF(o.BalanceEuro > 0, o.BalanceEuro, 0),
                       o.StatementIs,
                       @CurrencyID,
                       @Currency,
                       @CurrencyTypeIs,
                       @ExchangeRate,
                       1,
                       @NumberIs,
                       @ImageIs,
                       @DescriptionIs,
                       @DateDue,
                       @NotificationTextAR,
                       @NotificationTextEN
                FROM
                (
                    SELECT t.RowNumber,
                           t.AccountID,
                           Company.f_AccountGetName(t.AccountID) AS Account,
                           t.Balance,
                           Currencys.f_Format(@CurrencyID, t.Balance) AS BalanceF,
                           t.Balance / @ExchangeRate AS BalanceD,
                           Currencys.f_ExchangeToLL(@CurrencyID, t.Balance, t.Balance / @ExchangeRate) AS BalanceLL,
                           Currencys.f_ExchangeToEuro(@CurrencyID, t.Balance, t.Balance / @ExchangeRate) AS BalanceEuro,
                           Currencys.f_ToWordAR(Balance, @CurrencyID, 1) AS BalanceAR,
                           Currencys.f_ToWordEN(Balance, @CurrencyID, 1) AS BalanceEN,
                           IIF(Balance < 0, Balance, 0) AS Credit,
                           IIF(Balance > 0, Balance, 0) AS Debit,
                           REPLACE(t.StatementIs, N'{0}', @Ref) AS StatementIs
                    FROM @TransactionJV AS t
                ) AS o
                ORDER BY o.RowNumber;

            END;

            BEGIN --Fix data

                UPDATE Company.t_Account
                SET StatusIs = 0,
                    LastAction = GETDATE()
                WHERE EXISTS
                (
                    SELECT TOP (1)
                           s.ID
                    FROM @TransactionJV AS s
                    WHERE s.AccountID = t_Account.ID
                )
                      AND StatusIs = 1;

            END;

            BEGIN --Fix data

                UPDATE Transactions.t_Transaction
                SET BalanceD = COALESCE(
                               (
                                   SELECT SUM(s.Balance)
                                   FROM Transactions.t_TransactionDetail AS s
                                   WHERE s.TransactionID = t_Transaction.ID
                                         AND s.CurrencyTypeIs = 0
                                         AND s.Balance > 0
                               ),
                               0
                                       ),
                    BalanceLL = COALESCE(
                                (
                                    SELECT SUM(s.Balance)
                                    FROM Transactions.t_TransactionDetail AS s
                                    WHERE s.TransactionID = t_Transaction.ID
                                          AND s.CurrencyTypeIs = 1
                                          AND s.Balance > 0
                                ),
                                0
                                        ),
                    BalanceEuro = COALESCE(
                                  (
                                      SELECT SUM(s.Balance)
                                      FROM Transactions.t_TransactionDetail AS s
                                      WHERE s.TransactionID = t_Transaction.ID
                                            AND s.CurrencyTypeIs = 2
                                            AND s.Balance > 0
                                  ),
                                  0
                                          )
                WHERE ID = @TransactionID;

            END;

            BEGIN --Insert event

                SET @return = -1;

                INSERT INTO Transactions.t_TransactionMoving
                (
                    UserID,
                    SectionID,
                    EventIs,
                    EventType,
                    ComputerIP,
                    Computer,
                    ComputerAccount
                )
                VALUES
                (@UserID, @TransactionID, @Event + CONVERT(NVARCHAR(MAX), @RefJV), 0, @ComputerIP, @Computer,
                 @ComputerAccount);

            END;

        END;

        COMMIT TRANSACTION;

        SELECT 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT @return;

    END CATCH;

END;







GO
