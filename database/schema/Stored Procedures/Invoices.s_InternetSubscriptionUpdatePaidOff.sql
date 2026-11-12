SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_InternetSubscriptionUpdatePaidOff]
    @TransactionRV Transactions.dt_TransactionDetailShort READONLY ,
    @TransactionJVDescriptionIs NVARCHAR(MAX) ,
    @UserID UNIQUEIDENTIFIER ,
    @Event NVARCHAR(MAX) ,
    @EventInsert NVARCHAR(MAX) ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX) ,
    @ID UNIQUEIDENTIFIER
AS
    BEGIN
        BEGIN TRY

            BEGIN TRANSACTION;

            BEGIN --Declare

                DECLARE @IDs TABLE
                    (
                      ID UNIQUEIDENTIFIER NOT NULL
                    );

                DECLARE @Ref BIGINT ,
                    @RefRV BIGINT ,
                    @TransactionID UNIQUEIDENTIFIER ,
                    @Currency NVARCHAR(MAX) ,
                    @CurrencyTypeIs INT ,
                    @DateIs DATETIME ,
                    @CurrencyID UNIQUEIDENTIFIER ,
                    @ExchangeRate DECIMAL(18, 2) ,
                    @Paid FLOAT ,
                    @return INT;

            END;

            BEGIN --Set info

                SELECT TOP ( 1 )
                        @Ref = s.Ref ,
                        @DateIs = s.DateIs ,
                        @CurrencyID = s.CurrencyID ,
                        @ExchangeRate = s.ExchangeRate ,
                        @Paid = s.Price
                FROM    Invoices.t_InternetSubscription AS s
                WHERE   s.ID = @ID
                ORDER BY s.ID;

                SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);

                SET @CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID);

                SELECT TOP ( 1 )
                        @RefRV = s.Ref
                FROM    Transactions.t_Transaction AS s
                WHERE   s.LinkType = 18
                        AND s.LinkID = @ID
                        AND s.TypeIs = N'RV'
                ORDER BY s.ID;

            END;

            BEGIN --Update

                SET @return = 0;

                UPDATE  Invoices.t_InternetSubscription
                SET     Paid = Price ,
                        PaidF = PriceF ,
                        PaidD = PriceD ,
                        PaidLL = PriceLL ,
                        PaidEuro = PriceEuro ,
                        RestIs = 0 ,
                        RestIsF = Currencys.f_Format(@CurrencyID, 0) ,
                        RestIsD = 0 ,
                        RestIsLL = 0 ,
                        RestIsEuro = 0 ,
                        ProfitCollected = Profit ,
                        ProfitCollectedF = ProfitF ,
                        ProfitCollectedD = ProfitD ,
                        ProfitCollectedLL = ProfitLL ,
                        ProfitCollectedEuro = ProfitEuro ,
                        PatmentStatus = 2
                WHERE   ID = @ID;

            END;

            BEGIN --Insert event

                SET @return = -1;

                INSERT  INTO Invoices.t_InternetSubscriptionMoving
                        ( UserID ,
                          SectionID ,
                          EventIs ,
                          EventType ,
                          ComputerIP ,
                          Computer ,
                          ComputerAccount
                        )
                VALUES  ( @UserID ,
                          @ID ,
                          @Event ,
                          1 ,
                          @ComputerIP ,
                          @Computer ,
                          @ComputerAccount
                        );

            END;

            BEGIN --Delete old transaction

                DELETE  FROM Transactions.t_Transaction
                WHERE   LinkType = 18
                        AND LinkID = @ID
                        AND TypeIs = N'RV';

            END;

            IF @Paid > 0
                BEGIN --Transaction

                    IF @RefRV IS NULL
                        BEGIN --Set info

                            SELECT  @RefRV = ISNULL(MAX(s.Ref), 0) + 1
                            FROM    Transactions.t_Transaction AS s
                            WHERE   s.TypeIs = N'RV';

                        END;

                    BEGIN --Insert transaction

                        SET @return = 0;

                        DELETE  FROM @IDs;

                        INSERT  INTO Transactions.t_Transaction
                                ( Ref ,
                                  RefF ,
                                  TypeIs ,
                                  DateIs ,
                                  DateOnly ,
                                  DateFirstDayInMonth ,
                                  DateFirstDayInYear ,
                                  DescriptionIs ,
                                  AccountsNames ,
                                  LinkType ,
                                  LinkID ,
                                  UserID ,
                                  UserIs
                                )
                        OUTPUT  Inserted.ID
                                INTO @IDs ( ID )
                        VALUES  ( @RefRV ,
                                  FORMAT(@RefRV, 'n0') ,
                                  N'RV' ,
                                  @DateIs ,
                                  @DateIs ,
                                  DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs),
                                                1) ,
                                  DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
                                  REPLACE(@TransactionJVDescriptionIs, N'{0}',
                                          @Ref) ,
                                  Alls.f_FixXML(( SELECT DISTINCT
                                                            ', ' + t1.Name AS [text()]
                                                  FROM      @TransactionRV AS t
                                                            LEFT JOIN Company.t_Account
                                                            AS t1 ON t1.ID = t.AccountID
                                                FOR
                                                  XML PATH('')
                                                )) ,
                                  18 ,
                                  @ID ,
                                  @UserID ,
                                  Users.f_UserGetName(@UserID)
                                );

                        SET @TransactionID = ( SELECT TOP ( 1 )
                                                        s.ID
                                               FROM     @IDs AS s
                                               ORDER BY s.ID
                                             );

                    END;

                    BEGIN --Insert detail

                        INSERT  INTO Transactions.t_TransactionDetail
                                ( RowNumber ,
                                  TransactionID ,
                                  AccountID ,
                                  Account ,
                                  DateIs ,
                                  DateOnly ,
                                  DateFirstDayInMonth ,
                                  DateFirstDayInYear ,
                                  Balance ,
                                  BalanceF ,
                                  BalanceD ,
                                  BalanceLL ,
                                  BalanceEuro ,
                                  BalanceAR ,
                                  BalanceEN ,
                                  Credit ,
                                  CreditD ,
                                  CreditLL ,
                                  CreditEuro ,
                                  Debit ,
                                  DebitD ,
                                  DebitLL ,
                                  DebitEuro ,
                                  StatementIs ,
                                  CurrencyID ,
                                  Currency ,
                                  CurrencyTypeIs ,
                                  ExchangeRate
                                )
                                SELECT  o.RowNumber ,
                                        @TransactionID ,
                                        o.AccountID ,
                                        o.Account ,
                                        @DateIs ,
                                        @DateIs ,
                                        DATEFROMPARTS(YEAR(@DateIs),
                                                      MONTH(@DateIs), 1) ,
                                        DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
                                        o.Balance ,
                                        o.BalanceF ,
                                        o.BalanceD ,
                                        o.BalanceLL ,
                                        o.BalanceEuro ,
                                        o.BalanceAR ,
                                        o.BalanceEN ,
                                        ABS(o.Credit) ,
                                        ABS(IIF(o.BalanceD < 0, o.BalanceD, 0)) ,
                                        ABS(IIF(o.BalanceLL < 0, o.BalanceLL, 0)) ,
                                        ABS(IIF(o.BalanceEuro < 0, o.BalanceEuro, 0)) ,
                                        o.Debit ,
                                        IIF(o.BalanceD > 0, o.BalanceD, 0) ,
                                        IIF(o.BalanceLL > 0, o.BalanceLL, 0) ,
                                        IIF(o.BalanceEuro > 0, o.BalanceEuro, 0) ,
                                        o.StatementIs ,
                                        @CurrencyID ,
                                        @Currency ,
                                        @CurrencyTypeIs ,
                                        @ExchangeRate
                                FROM    ( SELECT    t.RowNumber ,
                                                    t.AccountID ,
                                                    Company.f_AccountGetName(t.AccountID) AS Account ,
                                                    t.Balance ,
                                                    Currencys.f_Format(@CurrencyID,
                                                              t.Balance) AS BalanceF ,
                                                    t.Balance / @ExchangeRate AS BalanceD ,
                                                    Currencys.f_ExchangeToLL(@CurrencyID,
                                                              t.Balance,
                                                              t.Balance
                                                              / @ExchangeRate) AS BalanceLL ,
                                                    Currencys.f_ExchangeToEuro(@CurrencyID,
                                                              t.Balance,
                                                              t.Balance
                                                              / @ExchangeRate) AS BalanceEuro ,
                                                    Currencys.f_ToWordAR(Balance,
                                                              @CurrencyID, 1) AS BalanceAR ,
                                                    Currencys.f_ToWordEN(Balance,
                                                              @CurrencyID, 1) AS BalanceEN ,
                                                    IIF(Balance < 0, Balance, 0) AS Credit ,
                                                    IIF(Balance > 0, Balance, 0) AS Debit ,
                                                    REPLACE(t.StatementIs,
                                                            N'{0}', @Ref) AS StatementIs
                                          FROM      @TransactionRV AS t
                                        ) AS o
                                ORDER BY o.RowNumber;

                    END;

                    BEGIN --Fix data

                        UPDATE  Company.t_Account
                        SET     StatusIs = 0 ,
                                LastAction = GETDATE()
                        WHERE   EXISTS ( SELECT TOP ( 1 )
                                                s.ID
                                         FROM   @TransactionRV AS s
                                         WHERE  s.AccountID = t_Account.ID )
                                AND StatusIs = 1;

                    END;

                    BEGIN --Fix data

                        UPDATE  Transactions.t_Transaction
                        SET     BalanceD = COALESCE(( SELECT  SUM(s.Balance)
                                                      FROM    Transactions.t_TransactionDetail
                                                              AS s
                                                      WHERE   s.TransactionID = t_Transaction.ID
                                                              AND s.CurrencyTypeIs = 0
                                                              AND s.Balance > 0
                                                    ), 0) ,
                                BalanceLL = COALESCE(( SELECT SUM(s.Balance)
                                                       FROM   Transactions.t_TransactionDetail
                                                              AS s
                                                       WHERE  s.TransactionID = t_Transaction.ID
                                                              AND s.CurrencyTypeIs = 1
                                                              AND s.Balance > 0
                                                     ), 0) ,
                                BalanceEuro = COALESCE(( SELECT
                                                              SUM(s.Balance)
                                                         FROM Transactions.t_TransactionDetail
                                                              AS s
                                                         WHERE
                                                              s.TransactionID = t_Transaction.ID
                                                              AND s.CurrencyTypeIs = 2
                                                              AND s.Balance > 0
                                                       ), 0)
                        WHERE   ID = @TransactionID;

                    END;

                    BEGIN --Insert event

                        SET @return = -1;

                        INSERT  INTO Transactions.t_TransactionMoving
                                ( UserID ,
                                  SectionID ,
                                  EventIs ,
                                  EventType ,
                                  ComputerIP ,
                                  Computer ,
                                  ComputerAccount
                                )
                        VALUES  ( @UserID ,
                                  @TransactionID ,
                                  @EventInsert + CONVERT(NVARCHAR(MAX), @RefRV) ,
                                  0 ,
                                  @ComputerIP ,
                                  @Computer ,
                                  @ComputerAccount
                                );

                    END;

                END;

            COMMIT TRANSACTION;

            SELECT  1;

        END TRY
        BEGIN CATCH

            ROLLBACK;

            SELECT  @return;

        END CATCH;

    END;







GO
