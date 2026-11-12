SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_ChequeUpdate]
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
    @EventInsert NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY

        SET ANSI_WARNINGS OFF;

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

            SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);

            SET @CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID);

            SELECT TOP (1)
                   @Ref = s.Ref
            FROM Company.t_Cheque AS s
            WHERE s.ID = @ID
            ORDER BY s.ID;

            SELECT TOP (1)
                   @RefJV = s.Ref
            FROM Transactions.t_Transaction AS s
            WHERE s.LinkType = 81
                  AND s.LinkID = @ID
                  AND s.TypeIs = N'JV'
            ORDER BY s.ID;

        END;

        BEGIN --Update

            SET @return = 0;

            UPDATE Company.t_Cheque
            SET NumberIs = @NumberIs,
                DateIs = @DateIs,
                BankID = @BankID,
                Bank = Company.f_BankGetName(@BankID),
                FromAccountID = @FromAccountID,
                ToAccountID = @ToAccountID,
                CurrencyID = @CurrencyID,
                Currency = @Currency,
                ExchangeRate = @ExchangeRate,
                Amount = @Amount,
                AmountF = Currencys.f_Format(@CurrencyID, @Amount),
                AmountD = @Amount / @ExchangeRate,
                AmountLL = Currencys.f_ExchangeToLL(@CurrencyID, @Amount, @Amount / @ExchangeRate),
                AmountEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Amount, @Amount / @ExchangeRate),
                AmountAR = Currencys.f_ToWordAR(@Amount, @CurrencyID, 1),
                AmountEN = Currencys.f_ToWordEN(@Amount, @CurrencyID, 1),
                BuildingID = @BuildingID,
                Building = Location.f_BuildingGetName(@BuildingID),
                Crosscheck = @Crosscheck,
                TypeIs = @TypeIs,
                TypeIsAR = CASE @TypeIs
                               WHEN 0 THEN
                                   N'داخل'
                               ELSE
                                   N'خارج'
                           END,
                TypeIsEN = CASE @TypeIs
                               WHEN 0 THEN
                                   N'Inside'
                               ELSE
                                   N'Outside'
                           END,
                ImageIs = @ImageIs,
                DateDue = @DateDue,
                DateDueMonthly = DATEFROMPARTS(YEAR(@DateDue), MONTH(@DateDue), 1),
                DateDueYearly = DATEFROMPARTS(YEAR(@DateDue), 1, 1),
                NotificationBeforeDays = @NotificationBeforeDays,
                NotificationDate = DATEADD(DAY, 0 - @NotificationBeforeDays, @DateDue),
                NotificationStop = 0,
                NotificationTextAR = @NotificationTextAR,
                NotificationTextEN = @NotificationTextEN,
                DescriptionIs = @DescriptionIs
            WHERE ID = @ID;

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
            (@UserID, @ID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

        END;

        BEGIN --Delete old transaction

            DELETE FROM Transactions.t_Transaction
            WHERE LinkType = 81
                  AND LinkID = @ID;

        END;

        BEGIN --Transaction

            IF @RefJV IS NULL
            BEGIN --Set info

                SELECT @RefJV = ISNULL(MAX(s.Ref), 0) + 1
                FROM Transactions.t_Transaction AS s
                WHERE s.TypeIs = N'JV';

            END;

            BEGIN --Insert transaction

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
                (@UserID, @TransactionID, @EventInsert + N': ' + CONVERT(NVARCHAR(MAX), @RefJV), 0, @ComputerIP,
                 @Computer, @ComputerAccount);

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
