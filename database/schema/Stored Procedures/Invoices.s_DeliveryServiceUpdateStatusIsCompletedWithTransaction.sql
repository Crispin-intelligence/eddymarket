SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_DeliveryServiceUpdateStatusIsCompletedWithTransaction]
    @PurchaseID UNIQUEIDENTIFIER ,
    @BoxID UNIQUEIDENTIFIER ,
    @MoveToHistory BIT ,
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
                    @VendorID UNIQUEIDENTIFIER ,
                    @Vendor NVARCHAR(MAX) ,
                    @CostCurrencyID UNIQUEIDENTIFIER ,
                    @CostCurrency NVARCHAR(MAX) ,
                    @CostExchangeRate DECIMAL(18, 2) ,
                    @CostExchangeRateLL DECIMAL(18, 2) ,
                    @CostExchangeRateEuro DECIMAL(18, 2) ,
                    @PaymentNew FLOAT ,
                    @PaymentNewD FLOAT ,
                    @CustomerID UNIQUEIDENTIFIER ,
                    @Customer NVARCHAR(MAX) ,
                    @DeliveryChargeCurrencyID UNIQUEIDENTIFIER ,
                    @DeliveryChargeCurrency NVARCHAR(MAX) ,
                    @DeliveryChargeExchangeRate DECIMAL(18, 2) ,
                    @DeliveryChargeExchangeRateLL DECIMAL(18, 2) ,
                    @DeliveryChargeExchangeRateEuro DECIMAL(18, 2) ,
                    @DeliveryCharge FLOAT ,
                    @DeliveryChargeD FLOAT ,
                    @DeliveryChargeStatus TINYINT ,
                    @EmployeeID UNIQUEIDENTIFIER ,
                    @Employee NVARCHAR(MAX) ,
                    @Expense FLOAT ,
                    @ExpenseD FLOAT ,
                    @ExpenseStatus TINYINT ,
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
                        @VendorID = s.AccountVendorID ,
                        @Vendor = s.AccountVendor ,
                        @CostCurrencyID = s.CostCurrencyID ,
                        @CostCurrency = s.CostCurrency ,
                        @CostExchangeRate = s.CostExchangeRate ,
                        @CostExchangeRateLL = s.CostExchangeRateLL ,
                        @CostExchangeRateEuro = s.CostExchangeRateEuro ,
                        @PaymentNew = s.Rest ,
                        @PaymentNewD = s.RestD ,
                        @CustomerID = s.AccountCustomerID ,
                        @Customer = s.AccountCustomer ,
                        @DeliveryChargeCurrencyID = s.DeliveryChargeCurrencyID ,
                        @DeliveryChargeCurrency = s.DeliveryChargeCurrency ,
                        @DeliveryChargeExchangeRate = s.DeliveryChargeExchangeRate ,
                        @DeliveryChargeExchangeRateLL = s.DeliveryChargeExchangeRateLL ,
                        @DeliveryChargeExchangeRateEuro = s.DeliveryChargeExchangeRateEuro ,
                        @DeliveryCharge = s.DeliveryCharge ,
                        @DeliveryChargeD = s.DeliveryChargeD ,
                        @DeliveryChargeStatus = s.DeliveryChargeStatus ,
                        @EmployeeID = s.AccountEmployeeID ,
                        @Employee = s.AccountEmployee ,
                        @Expense = s.Expense ,
                        @ExpenseD = s.ExpenseD ,
                        @ExpenseStatus = s.ExpenseStatus
                FROM    Invoices.t_DeliveryService AS s
                WHERE   s.ID = @ID;
        	
                SET @DateIs = GETDATE();

            END;

            BEGIN --Update

                SET @return = 0;

                UPDATE  Invoices.t_DeliveryService
                SET     StatusIs = 4 ,
                        StatusIsAR = Invoices.f_DeliveryServiceGetStatusIsAR(4) ,
                        StatusIsEN = Invoices.f_DeliveryServiceGetStatusIsEN(4) ,
                        Payment = Cost ,
                        PaymentF = CostF ,
                        PaymentD = CostD ,
                        PaymentLL = CostLL ,
                        PaymentEuro = CostEuro ,
                        Rest = 0 ,
                        RestF = Currencys.f_Format(CostCurrencyID, 0) ,
                        RestD = 0 ,
                        RestLL = 0 ,
                        RestEuro = 0 ,
                        DeliveryChargeStatus = 1 ,
                        DeliveryChargeStatusAR = Invoices.f_DeliveryServiceGetDeliveryChargeStatusAR(1) ,
                        DeliveryChargeStatusEN = Invoices.f_DeliveryServiceGetDeliveryChargeStatusEN(1) ,
                        ExpenseStatus = 1 ,
                        ExpenseStatusAR = Invoices.f_DeliveryServiceGetExpenseStatusAR(1) ,
                        ExpenseStatusEN = Invoices.f_DeliveryServiceGetExpenseStatusEN(1) ,
                        ProcessIn = 1
                WHERE   ID = @ID;

            END;

            IF @MoveToHistory = 1
                BEGIN --Move to history
                          
                    INSERT  INTO Invoices.t_DeliveryServiceHistory
                            ( ID ,
                              Ref ,
                              RefF ,
                              RefPaper ,
                              DateIs ,
                              DateOnly ,
                              TimeOnly ,
                              DateMonthly ,
                              DateYearly ,
                              TypeIs ,
                              TypeIsAR ,
                              TypeIsEN ,
                              StatusIs ,
                              StatusIsAR ,
                              StatusIsEN ,
                              DescriptionIs ,
                              UserID ,
                              UserIs ,
                              AccountVendorID ,
                              AccountVendor ,
                              AccountVendorNumber ,
                              FromAddress ,
                              ItemsNames ,
                              CostCurrencyID ,
                              CostCurrency ,
                              CostExchangeRate ,
                              CostExchangeRateLL ,
                              CostExchangeRateEuro ,
                              Cost ,
                              CostF ,
                              CostD ,
                              CostLL ,
                              CostEuro ,
                              Payment ,
                              PaymentF ,
                              PaymentD ,
                              PaymentLL ,
                              PaymentEuro ,
                              Rest ,
                              RestF ,
                              RestD ,
                              RestLL ,
                              RestEuro ,
                              AccountCustomerID ,
                              AccountCustomer ,
                              AccountCustomerNumber ,
                              AccountCustomerIsVendor ,
                              ToAddress ,
                              DeliveryDate ,
                              DeliveryChargeCurrencyID ,
                              DeliveryChargeCurrency ,
                              DeliveryChargeExchangeRate ,
                              DeliveryChargeExchangeRateLL ,
                              DeliveryChargeExchangeRateEuro ,
                              DeliveryCharge ,
                              DeliveryChargeF ,
                              DeliveryChargeD ,
                              DeliveryChargeLL ,
                              DeliveryChargeEuro ,
                              DeliveryChargeStatus ,
                              DeliveryChargeStatusAR ,
                              DeliveryChargeStatusEN ,
                              AccountEmployeeID ,
                              AccountEmployee ,
                              AccountEmployeeNumber ,
                              AssignDate ,
                              Expense ,
                              ExpenseF ,
                              ExpenseD ,
                              ExpenseLL ,
                              ExpenseEuro ,
                              ExpenseStatus ,
                              ExpenseStatusAR ,
                              ExpenseStatusEN ,
                              ExpensePaymentDate ,
                              DateCreate ,
                              IsSync ,
                              WorkStationID
			                )
                            SELECT  t.ID ,
                                    t.Ref ,
                                    t.RefF ,
                                    t.RefPaper ,
                                    t.DateIs ,
                                    t.DateOnly ,
                                    t.TimeOnly ,
                                    t.DateMonthly ,
                                    t.DateYearly ,
                                    t.TypeIs ,
                                    t.TypeIsAR ,
                                    t.TypeIsEN ,
                                    t.StatusIs ,
                                    t.StatusIsAR ,
                                    t.StatusIsEN ,
                                    t.DescriptionIs ,
                                    t.UserID ,
                                    t.UserIs ,
                                    t.AccountVendorID ,
                                    t.AccountVendor ,
                                    t.AccountVendorNumber ,
                                    t.FromAddress ,
                                    t.ItemsNames ,
                                    t.CostCurrencyID ,
                                    t.CostCurrency ,
                                    t.CostExchangeRate ,
                                    t.CostExchangeRateLL ,
                                    t.CostExchangeRateEuro ,
                                    t.Cost ,
                                    t.CostF ,
                                    t.CostD ,
                                    t.CostLL ,
                                    t.CostEuro ,
                                    t.Payment ,
                                    t.PaymentF ,
                                    t.PaymentD ,
                                    t.PaymentLL ,
                                    t.PaymentEuro ,
                                    t.Rest ,
                                    t.RestF ,
                                    t.RestD ,
                                    t.RestLL ,
                                    t.RestEuro ,
                                    t.AccountCustomerID ,
                                    t.AccountCustomer ,
                                    t.AccountCustomerNumber ,
                                    t.AccountCustomerIsVendor ,
                                    t.ToAddress ,
                                    t.DeliveryDate ,
                                    t.DeliveryChargeCurrencyID ,
                                    t.DeliveryChargeCurrency ,
                                    t.DeliveryChargeExchangeRate ,
                                    t.DeliveryChargeExchangeRateLL ,
                                    t.DeliveryChargeExchangeRateEuro ,
                                    t.DeliveryCharge ,
                                    t.DeliveryChargeF ,
                                    t.DeliveryChargeD ,
                                    t.DeliveryChargeLL ,
                                    t.DeliveryChargeEuro ,
                                    t.DeliveryChargeStatus ,
                                    t.DeliveryChargeStatusAR ,
                                    t.DeliveryChargeStatusEN ,
                                    t.AccountEmployeeID ,
                                    t.AccountEmployee ,
                                    t.AccountEmployeeNumber ,
                                    t.AssignDate ,
                                    t.Expense ,
                                    t.ExpenseF ,
                                    t.ExpenseD ,
                                    t.ExpenseLL ,
                                    t.ExpenseEuro ,
                                    t.ExpenseStatus ,
                                    t.ExpenseStatusAR ,
                                    t.ExpenseStatusEN ,
                                    t.ExpensePaymentDate ,
                                    t.DateCreate ,
                                    t.IsSync ,
                                    t.WorkStationID
                            FROM    Invoices.t_DeliveryService AS t
                            WHERE   t.ID = @ID;

                    BEGIN --Delete

                        DELETE  FROM Invoices.t_DeliveryService
                        WHERE   ID = @ID;

                    END;

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

            IF @PaymentNew > 0
                BEGIN --Transaction

                    BEGIN --Set info

                        SELECT  @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
                        FROM    Transactions.t_Transaction AS s
                        WHERE   s.TypeIs = N'JV';

                    END;

                    BEGIN --Insert transaction

                        SET @return = 0;

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
                                  2 ,
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

                        SET @CID = @CostCurrencyID;
                        SET @E = @CostExchangeRate;
                        SET @ELL = @CostExchangeRateLL;
                        SET @EEuro = @CostExchangeRateEuro;
                        SET @V = @PaymentNew;
                        SET @VD = @PaymentNewD;

                        INSERT  INTO Transactions.t_TransactionDetail
                                ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro,
                                  Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
                        VALUES  ( 1, @TransactionID, @VendorID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro,
                                  N'DS:' + @RefF, @CID, @E ),
                                ( 2, @TransactionID, @PurchaseID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL,
                                  @VD * @EEuro, 0, 0, 0, 0, N'DS:' + @RefF + ' \ ' + @Vendor, @CID, @E );

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

            IF @DeliveryChargeStatus = 0
                AND @DeliveryCharge > 0
                BEGIN --Transaction

                    BEGIN --Set info

                        SELECT  @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
                        FROM    Transactions.t_Transaction AS s
                        WHERE   s.TypeIs = N'RV';

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
                                  N'RV' ,
                                  @DateIs ,
                                  N'DS:' + @RefF ,
                                  162 ,
                                  4 ,
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

                        SET @CID = @DeliveryChargeCurrencyID;
                        SET @E = @DeliveryChargeExchangeRate;
                        SET @ELL = @DeliveryChargeExchangeRateLL;
                        SET @EEuro = @DeliveryChargeExchangeRateEuro;
                        SET @V = @DeliveryCharge;
                        SET @VD = @DeliveryChargeD;

                        INSERT  INTO Transactions.t_TransactionDetail
                                ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro,
                                  Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
                        VALUES  ( 1, @TransactionID, @BoxID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro,
                                  N'DS:' + @RefF + ' \ ' + @Customer, @CID, @E ),
                                ( 2, @TransactionID, @CustomerID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL,
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
      
            IF @ExpenseStatus = 0
                AND @Expense > 0
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
                                  6 ,
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

                        SET @CID = @DeliveryChargeCurrencyID;
                        SET @E = @DeliveryChargeExchangeRate;
                        SET @ELL = @DeliveryChargeExchangeRateLL;
                        SET @EEuro = @DeliveryChargeExchangeRateEuro;
                        SET @V = @Expense;
                        SET @VD = @ExpenseD;

                        INSERT  INTO Transactions.t_TransactionDetail
                                ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro,
                                  Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
                        VALUES  ( 1, @TransactionID, @EmployeeID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro,
                                  N'DS:' + @RefF, @CID, @E ),
                                ( 2, @TransactionID, @BoxID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL,
                                  @VD * @EEuro, 0, 0, 0, 0, N'DS:' + @RefF + ' \ ' + @Employee, @CID, @E );

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
                WHERE   ID IN ( @PurchaseID, @VendorID, @BoxID, @CustomerID, @EmployeeID )
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
