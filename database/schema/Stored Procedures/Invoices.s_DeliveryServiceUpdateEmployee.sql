SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_DeliveryServiceUpdateEmployee]
    @EmployeeID UNIQUEIDENTIFIER ,
    @EmployeeSalaryID UNIQUEIDENTIFIER ,
    @UserID UNIQUEIDENTIFIER ,
    @EventInsert NVARCHAR(MAX) ,
    @Event NVARCHAR(MAX) ,
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

                DECLARE @TransactionIDs TABLE
                    (
                      ID UNIQUEIDENTIFIER NOT NULL
                    );

                DECLARE @RefF NVARCHAR(MAX) ,
                    @DateIs DATETIME ,
                    @Employee NVARCHAR(MAX) ,
                    @CurrencyID UNIQUEIDENTIFIER ,
                    @Currency NVARCHAR(MAX) ,
                    @ExchangeRate DECIMAL(18, 2) ,
                    @ExchangeRateLL DECIMAL(18, 2) ,
                    @ExchangeRateEuro DECIMAL(18, 2) ,
                    @Expense FLOAT ,
                    @ExpenseD FLOAT ,
                    @TransactionID UNIQUEIDENTIFIER ,
                    @TransactionRef BIGINT ,
                    @return INT ,
                    @CID UNIQUEIDENTIFIER ,
                    @E DECIMAL(18, 2) ,
                    @ELL DECIMAL(18, 2) ,
                    @EEuro DECIMAL(18, 2) ,
                    @V FLOAT ,
                    @VD FLOAT;

            END;

            BEGIN --Set info

                SELECT TOP ( 1 )
                        @RefF = s.RefF ,
                        @CurrencyID = s.DeliveryChargeCurrencyID ,
                        @Currency = s.DeliveryChargeCurrency ,
                        @ExchangeRate = s.DeliveryChargeExchangeRate ,
                        @ExchangeRateLL = s.DeliveryChargeExchangeRateLL ,
                        @ExchangeRateEuro = s.DeliveryChargeExchangeRateEuro ,
                        @Expense = s.Expense ,
                        @ExpenseD = s.ExpenseD
                FROM    Invoices.t_DeliveryService AS s
                WHERE   s.ID = @ID;
        	
                SET @DateIs = GETDATE();

                SET @Employee = Company.f_AccountGetName(@EmployeeID);

            END;
			
            BEGIN --Update

                SET @return = 0;

                UPDATE  Invoices.t_DeliveryService
                SET     StatusIs = 1 ,
                        StatusIsAR = Invoices.f_DeliveryServiceGetStatusIsAR(1) ,
                        StatusIsEN = Invoices.f_DeliveryServiceGetStatusIsEN(1) ,
                        AccountEmployeeID = @EmployeeID ,
                        AccountEmployee = @Employee ,
                        AccountEmployeeNumber = Company.f_AccountGetNumberF(@EmployeeID) ,
                        AssignDate = @DateIs
                WHERE   ID = @ID;

            END;

            BEGIN --Insert event

                SET @return = -1;

                INSERT  INTO Invoices.t_DeliveryServiceMoving
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

            IF @Expense > 0
                BEGIN --Transaction

                    BEGIN --Set info

                        SELECT  @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
                        FROM    Transactions.t_Transaction AS s
                        WHERE   s.TypeIs = N'JV';

                    END;

                    BEGIN --Insert transaction

                        SET @return = 0;

                        DELETE  FROM @IDs;

                        INSERT  INTO Transactions.t_Transaction
                                ( Ref ,
                                  TypeIs ,
                                  DateIs ,
                                  DescriptionIs ,
                                  LinkType ,
                                  LinkTypeSub ,
                                  LinkID ,
                                  UserID
                                )
                        OUTPUT  Inserted.ID
                                INTO @IDs ( ID )
                        VALUES  ( @TransactionRef ,
                                  N'JV' ,
                                  @DateIs ,
                                  N'DS:' + @RefF ,
                                  162 ,
                                  5 ,
                                  @ID ,
                                  @UserID 
                                );

                        SET @TransactionID = ( SELECT TOP ( 1 )
                                                        s.ID
                                               FROM     @IDs AS s
                                               ORDER BY s.ID
                                             );

                        INSERT  @TransactionIDs
                                ( ID )
                        VALUES  ( @TransactionID );

                    END;

                    BEGIN --Insert detail
					
                        SET @CID = @CurrencyID;
                        SET @E = @ExchangeRate;
                        SET @ELL = @ExchangeRateLL;
                        SET @EEuro = @ExchangeRateEuro;
                        SET @V = @Expense;
                        SET @VD = @ExpenseD;

                        INSERT  INTO Transactions.t_TransactionDetail
                                ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro,
                                  Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
                        VALUES  ( 1, @TransactionID, @EmployeeSalaryID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL,
                                  @VD * @EEuro, N'DS:' + @RefF, @CID, @E ),
                                ( 2, @TransactionID, @EmployeeID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL,
                                  @VD * @EEuro, 0, 0, 0, 0, N'DS:' + @RefF, @CID, @E );

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
                                  @EventInsert + CONVERT(NVARCHAR(MAX), @TransactionRef) ,
                                  0 ,
                                  @ComputerIP ,
                                  @Computer ,
                                  @ComputerAccount
                                );

                    END;

                END;

            BEGIN --Fix data

                UPDATE  Company.t_Account
                SET     StatusIs = 0 ,
                        LastAction = GETDATE()
                WHERE   ID IN ( @EmployeeID, @EmployeeSalaryID )
                        AND StatusIs = 1;
                 
                UPDATE  Transactions.t_Transaction
                SET     RefF = FORMAT(Ref, 'n0') ,
                        DateOnly = DateIs ,
                        DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
                        DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
                        AccountsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                                ', ' + t.Account AS [text()]
                                                        FROM    Transactions.t_TransactionDetail AS t
                                                        WHERE   t.TransactionID = @TransactionID
                                                      FOR
                                                        XML PATH('')
                                                      )) ,
                        BalanceD = COALESCE(( SELECT    SUM(s.Balance)
                                              FROM      Transactions.t_TransactionDetail AS s
                                              WHERE     s.TransactionID = t_Transaction.ID
                                                        AND s.CurrencyTypeIs = 0
                                                        AND s.Balance > 0
                                            ), 0) ,
                        BalanceLL = COALESCE(( SELECT   SUM(s.Balance)
                                               FROM     Transactions.t_TransactionDetail AS s
                                               WHERE    s.TransactionID = t_Transaction.ID
                                                        AND s.CurrencyTypeIs = 1
                                                        AND s.Balance > 0
                                             ), 0) ,
                        BalanceEuro = COALESCE(( SELECT SUM(s.Balance)
                                                 FROM   Transactions.t_TransactionDetail AS s
                                                 WHERE  s.TransactionID = t_Transaction.ID
                                                        AND s.CurrencyTypeIs = 2
                                                        AND s.Balance > 0
                                               ), 0) ,
                        UserIs = Users.f_UserGetName(UserID)
                WHERE   EXISTS ( SELECT TOP ( 1 )
                                        s.ID
                                 FROM   @TransactionIDs AS s
                                 WHERE  s.ID = t_Transaction.ID );

                UPDATE  Transactions.t_TransactionDetail
                SET     Account = Company.f_AccountGetName(AccountID) ,
                        DateOnly = DateIs ,
                        DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
                        DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
                        Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
                        CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(CurrencyID) ,
                        BalanceF = Currencys.f_Format(CurrencyID, Balance) ,
                        BalanceAR = Currencys.f_ToWordAR(Balance, CurrencyID, 1) ,
                        BalanceEN = Currencys.f_ToWordEN(Balance, CurrencyID, 1)
                WHERE   EXISTS ( SELECT TOP ( 1 )
                                        s.ID
                                 FROM   @TransactionIDs AS s
                                 WHERE  s.ID = t_TransactionDetail.TransactionID );

            END;

            COMMIT TRANSACTION;

            RETURN  1;

        END TRY
        BEGIN CATCH

            ROLLBACK;

            RETURN  @return;

        END CATCH;

    END;



GO
