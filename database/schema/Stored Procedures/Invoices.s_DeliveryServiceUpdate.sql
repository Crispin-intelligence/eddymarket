SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_DeliveryServiceUpdate] @RefPaper NVARCHAR(MAX) ,
  @DateIs DATETIME ,
  @TypeIs TINYINT ,
  @StatusIs TINYINT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @VendorID UNIQUEIDENTIFIER ,
  @FromAddress NVARCHAR(MAX) ,
  @ItemsNames NVARCHAR(MAX) ,
  @CostCurrencyID UNIQUEIDENTIFIER ,
  @CostExchangeRate DECIMAL(18, 2) ,
  @CostExchangeRateLL DECIMAL(18, 2) ,
  @CostExchangeRateEuro DECIMAL(18, 2) ,
  @Cost FLOAT ,
  @Payment FLOAT ,
  @CustomerID UNIQUEIDENTIFIER ,
  @ToAddress NVARCHAR(MAX) ,
  @DeliveryDate DATETIME ,
  @DeliveryChargeCurrencyID UNIQUEIDENTIFIER ,
  @DeliveryChargeExchangeRate DECIMAL(18, 2) ,
  @DeliveryChargeExchangeRateLL DECIMAL(18, 2) ,
  @DeliveryChargeExchangeRateEuro DECIMAL(18, 2) ,
  @DeliveryCharge FLOAT ,
  @DeliveryChargeStatus TINYINT ,
  @EmployeeID UNIQUEIDENTIFIER ,
  @EmployeeSalaryID UNIQUEIDENTIFIER ,
  @AssignDate DATETIME ,
  @Expense FLOAT ,
  @ExpenseStatus TINYINT ,
  @ExpensePaymentDate DATETIME ,
  @PurchaseID UNIQUEIDENTIFIER ,
  @BoxID UNIQUEIDENTIFIER ,
  @SaleID UNIQUEIDENTIFIER ,
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
          ID UNIQUEIDENTIFIER NOT NULL ,
          RefF NVARCHAR(MAX) NOT NULL
        );

      DECLARE @RefF NVARCHAR(MAX) ,
        @TransactionID UNIQUEIDENTIFIER ,
        @TransactionRef BIGINT ,
        @Vendor NVARCHAR(MAX) ,
        @CostCurrency NVARCHAR(MAX) ,
        @CustomerIDOld UNIQUEIDENTIFIER ,
        @Customer NVARCHAR(MAX) ,
        @DeliveryChargeCurrency NVARCHAR(MAX) ,
        @Employee NVARCHAR(MAX) ,
        @EmployeeSalary NVARCHAR(MAX) ,
        @Purchase NVARCHAR(MAX) ,
        @Box NVARCHAR(MAX) ,
        @Sale NVARCHAR(MAX) ,
        @CostD FLOAT ,
        @PaymentD FLOAT ,
        @Rest FLOAT ,
        @RestD FLOAT ,
        @DeliveryChargeD FLOAT ,
        @ExpenseD FLOAT ,
        @return INT ,
        @LinkType TINYINT = 162 ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @VD FLOAT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 ) @RefF = s.RefF ,
          @CustomerIDOld = s.AccountCustomerID
        FROM Invoices.t_DeliveryService AS s
        WHERE s.ID = @ID;

      SET @Vendor = Company.f_AccountGetName(@VendorID);

      SET @CostCurrency = Currencys.f_CurrencyGetName(@CostCurrencyID);
		
      SET @Customer = Company.f_AccountGetName(@CustomerID);
	          
      SET @DeliveryChargeCurrency = Currencys.f_CurrencyGetName(@DeliveryChargeCurrencyID);
        
      SET @Employee = Company.f_AccountGetName(@EmployeeID);

      SET @EmployeeSalary = Company.f_AccountGetName(@EmployeeSalaryID);

      SET @Purchase = Company.f_AccountGetName(@PurchaseID);

      SET @Box = Company.f_AccountGetName(@BoxID);

      SET @Sale = Company.f_AccountGetName(@SaleID);
	          	
      SET @CostD = @Cost / @CostExchangeRate;

      SET @PaymentD = @Payment / @CostExchangeRate;

      SET @Rest = @Cost - @Payment;

      SET @RestD = @Rest / @CostExchangeRate;

      SET @DeliveryChargeD = @DeliveryCharge / @DeliveryChargeExchangeRate;

      SET @ExpenseD = @Expense / @DeliveryChargeExchangeRate;
				              
      IF @EmployeeID = '00000000-0000-0000-0000-000000000000'
      BEGIN
			                                                               
        SET @AssignDate = DATETIMEFROMPARTS(2000, 1, 1, 0, 0, 0, 0);

      END;

      IF @ExpenseStatus = 0
      BEGIN
						                          
        SET @ExpensePaymentDate = DATETIMEFROMPARTS(2000, 1, 1, 0, 0, 0, 0);

      END;

    END;

    BEGIN --Insert

      SET @return = 0;

      UPDATE Invoices.t_DeliveryService
        SET RefPaper = @RefPaper ,
            DateIs = @DateIs ,
            DateOnly = @DateIs ,
            TimeOnly = @DateIs ,
            DateMonthly = DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
            DateYearly = DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
            TypeIs = @TypeIs ,
            TypeIsAR = Invoices.f_DeliveryServiceGetTypeIsAR(@TypeIs) ,
            TypeIsEN = Invoices.f_DeliveryServiceGetTypeIsEN(@TypeIs) ,
            StatusIs = @StatusIs ,
            StatusIsAR = Invoices.f_DeliveryServiceGetStatusIsAR(@StatusIs) ,
            StatusIsEN = Invoices.f_DeliveryServiceGetStatusIsEN(@StatusIs) ,
            DescriptionIs = @DescriptionIs ,
            AccountVendorID = @VendorID ,
            AccountVendor = @Vendor ,
            AccountVendorNumber = Company.f_AccountGetNumberF(@VendorID) ,
            FromAddress = @FromAddress ,
            ItemsNames = @ItemsNames ,
            CostCurrencyID = @CostCurrencyID ,
            CostCurrency = @CostCurrency ,
            CostExchangeRate = @CostExchangeRate ,
            CostExchangeRateLL = @CostExchangeRateLL ,
            CostExchangeRateEuro = @CostExchangeRateEuro ,
            Cost = @Cost ,
            CostF = Currencys.f_Format(@CostCurrencyID, @Cost) ,
            CostD = @CostD ,
            CostLL = @CostD * @CostExchangeRateLL ,
            CostEuro = @CostD * @CostExchangeRateEuro ,
            Payment = @Payment ,
            PaymentF = Currencys.f_Format(@CostCurrencyID, @Payment) ,
            PaymentD = @PaymentD ,
            PaymentLL = @PaymentD * @CostExchangeRateLL ,
            PaymentEuro = @PaymentD * @CostExchangeRateEuro ,
            Rest = @Rest ,
            RestF = Currencys.f_Format(@CostCurrencyID, @Rest) ,
            RestD = @RestD ,
            RestLL = @RestD * @CostExchangeRateLL ,
            RestEuro = @RestD * @CostExchangeRateEuro ,
            AccountCustomerID = @CustomerID ,
            AccountCustomer = @Customer ,
            AccountCustomerNumber = Company.f_AccountGetNumberF(@CustomerID) ,
            ToAddress = @ToAddress ,
            DeliveryDate = @DeliveryDate ,
            DeliveryChargeCurrencyID = @DeliveryChargeCurrencyID ,
            DeliveryChargeCurrency = @DeliveryChargeCurrency ,
            DeliveryChargeExchangeRate = @DeliveryChargeExchangeRate ,
            DeliveryChargeExchangeRateLL = @DeliveryChargeExchangeRateLL ,
            DeliveryChargeExchangeRateEuro = @DeliveryChargeExchangeRateEuro ,
            DeliveryCharge = @DeliveryCharge ,
            DeliveryChargeF = Currencys.f_Format(@DeliveryChargeCurrencyID, @DeliveryCharge) ,
            DeliveryChargeD = @DeliveryChargeD ,
            DeliveryChargeLL = @DeliveryChargeD * @DeliveryChargeExchangeRateLL ,
            DeliveryChargeEuro = @DeliveryChargeD * @DeliveryChargeExchangeRateEuro ,
            DeliveryChargeStatus = @DeliveryChargeStatus ,
            DeliveryChargeStatusAR = Invoices.f_DeliveryServiceGetDeliveryChargeStatusAR(@DeliveryChargeStatus) ,
            DeliveryChargeStatusEN = Invoices.f_DeliveryServiceGetDeliveryChargeStatusEN(@DeliveryChargeStatus) ,
            AccountEmployeeID = @EmployeeID ,
            AccountEmployee = @Employee ,
            AccountEmployeeNumber = Company.f_AccountGetNumberF(@EmployeeID) ,
            AssignDate = @AssignDate ,
            Expense = @Expense ,
            ExpenseF = Currencys.f_Format(@DeliveryChargeCurrencyID, @Expense) ,
            ExpenseD = @ExpenseD ,
            ExpenseLL = @ExpenseD * @DeliveryChargeExchangeRateLL ,
            ExpenseEuro = @ExpenseD * @DeliveryChargeExchangeRateEuro ,
            ExpenseStatus = @ExpenseStatus ,
            ExpenseStatusAR = Invoices.f_DeliveryServiceGetExpenseStatusAR(@ExpenseStatus) ,
            ExpenseStatusEN = Invoices.f_DeliveryServiceGetExpenseStatusEN(@ExpenseStatus) ,
            ExpensePaymentDate = IIF(@ExpenseStatus = 0, DATETIMEFROMPARTS(2000, 1, 1, 0, 0, 0, 0), @ExpensePaymentDate)
        WHERE ID = @ID;

    END;

    BEGIN --Fix data t_DeliveryService

      UPDATE Invoices.t_DeliveryService
        SET ProcessIn = CASE WHEN Rest > 0 THEN 0
                             WHEN DeliveryCharge > 0 AND DeliveryChargeStatus = 0 THEN 0
                             WHEN Expense > 0 AND ExpenseStatus = 0 THEN 0
                             ELSE 1
                        END ,
            AccountCustomerIsVendor = IIF(AccountCustomerID = AccountVendorID, 1, 0)
        WHERE ID = @ID;

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Invoices.t_DeliveryServiceMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        VALUES
          ( @UserID ,
            @ID ,
            @Event + @RefF ,
            1 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    IF @EmployeeID <> '00000000-0000-0000-0000-000000000000' AND @Expense > 0
    BEGIN
						
      WITH  o AS ( SELECT s1.SalaryDeliveryService ,
                      Currencys.f_ExchangeToAccountCurrency(@DeliveryChargeCurrencyID, @DeliveryChargeExchangeRate, @Expense, s1.CurrencyID) AS SalaryDeliveryService_ ,
                      s1.SalaryDeliveryServiceF ,
                      s1.CurrencyID
                    FROM Company.t_Account AS s
                      INNER JOIN Employees.t_Employee AS s1 ON s.LinkWithID = s1.ID
                    WHERE s.ID = @EmployeeID
                 )
        UPDATE o
          SET o.SalaryDeliveryService = o.SalaryDeliveryService_ ,
              o.SalaryDeliveryServiceF = Currencys.f_Format(o.CurrencyID, o.SalaryDeliveryService_);

    END;

    BEGIN --Delete old Transaction
  							           
      DELETE FROM Transactions.t_Transaction
        WHERE LinkType = @LinkType AND LinkID = @ID;

    END;

    IF @Cost > 0
    BEGIN --Transaction

      BEGIN --Set info
                           
        SELECT @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = N'JV';		      

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE FROM @IDs;

        INSERT INTO Transactions.t_Transaction
            ( Ref ,
              TypeIs ,
              DateIs ,
              DescriptionIs ,
              LinkType ,
              LinkTypeSub ,
              LinkID ,
              UserID
            )
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @TransactionRef ,
              N'JV' ,
              @DateIs ,
              N'DS:' + @RefF ,
              @LinkType ,
              1 ,
              @ID ,
              @UserID
            );

        SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                FROM @IDs AS s
                                ORDER BY s.ID
                             );

        INSERT @TransactionIDs
            ( ID ,
              RefF
            )
          VALUES
            ( @TransactionID ,
              CONVERT(NVARCHAR(MAX), @TransactionRef)
            );

      END;

      BEGIN --Insert detail

        SET @CID = @CostCurrencyID;
        SET @E = @CostExchangeRate;
        SET @ELL = @CostExchangeRateLL;
        SET @EEuro = @CostExchangeRateEuro;
        SET @V = @Cost;
        SET @VD = @CostD;

        INSERT INTO Transactions.t_TransactionDetail
            ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro, Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
          VALUES  ( 1, @TransactionID, @PurchaseID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro, N'DS:' + @RefF + ' \ ' + @Vendor, @CID, @E ),
                  ( 2, @TransactionID, @VendorID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, N'DS:' + @RefF, @CID, @E );
	  
      END;

    END;

    IF @Payment > 0
    BEGIN --Transaction
                    
      BEGIN --Set info

        SELECT @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = N'JV';		      

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE FROM @IDs;

        INSERT INTO Transactions.t_Transaction
            ( Ref ,
              TypeIs ,
              DateIs ,
              DescriptionIs ,
              LinkType ,
              LinkTypeSub ,
              LinkID ,
              UserID
            )
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @TransactionRef ,
              N'JV' ,
              @DateIs ,
              N'DS:' + @RefF ,
              @LinkType ,
              2 ,
              @ID ,
              @UserID
            );

        SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                FROM @IDs AS s
                                ORDER BY s.ID
                             );

        INSERT @TransactionIDs
            ( ID ,
              RefF
            )
          VALUES
            ( @TransactionID ,
              CONVERT(NVARCHAR(MAX), @TransactionRef)
            );

      END;

      BEGIN --Insert detail

        SET @CID = @CostCurrencyID;
        SET @E = @CostExchangeRate;
        SET @ELL = @CostExchangeRateLL;
        SET @EEuro = @CostExchangeRateEuro;
        SET @V = @Payment;
        SET @VD = @PaymentD;

        INSERT INTO Transactions.t_TransactionDetail
            ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro, Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
          VALUES  ( 1, @TransactionID, @VendorID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro, N'DS:' + @RefF, @CID, @E ),
                  ( 2, @TransactionID, @PurchaseID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, N'DS:' + @RefF + ' \ ' + @Vendor, @CID, @E );

      END;

    END;

    IF @DeliveryCharge > 0
    BEGIN --Transaction
				
      BEGIN --Set info
                           
        SELECT @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = N'JV';		      

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE FROM @IDs;

        INSERT INTO Transactions.t_Transaction
            ( Ref ,
              TypeIs ,
              DateIs ,
              DescriptionIs ,
              LinkType ,
              LinkTypeSub ,
              LinkID ,
              UserID 
            )
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @TransactionRef ,
              N'JV' ,
              @DateIs ,
              N'DS:' + @RefF ,
              @LinkType ,
              3 ,
              @ID ,
              @UserID 
            );

        SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                FROM @IDs AS s
                                ORDER BY s.ID
                             );
              
        INSERT @TransactionIDs
            ( ID ,
              RefF
            )
          VALUES
            ( @TransactionID ,
              CONVERT(NVARCHAR(MAX), @TransactionRef)
            );

      END;

      BEGIN --Insert detail

        SET @CID = @DeliveryChargeCurrencyID;
        SET @E = @DeliveryChargeExchangeRate;
        SET @ELL = @DeliveryChargeExchangeRateLL;
        SET @EEuro = @DeliveryChargeExchangeRateEuro;
        SET @V = @DeliveryCharge;
        SET @VD = @DeliveryChargeD;

        INSERT INTO Transactions.t_TransactionDetail
            ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro, Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
          VALUES  ( 1, @TransactionID, @CustomerID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro, N'DS:' + @RefF, @CID, @E ),
                  ( 2, @TransactionID, @SaleID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, N'DS:' + @RefF + ' \ ' + @Customer, @CID, @E );

      END;

    END;

    IF @DeliveryCharge > 0 AND @DeliveryChargeStatus = 1
    BEGIN --Transaction
              
      BEGIN --Set info
                           
        SELECT @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = N'RV';		      

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE FROM @IDs;

        INSERT INTO Transactions.t_Transaction
            ( Ref ,
              TypeIs ,
              DateIs ,
              DescriptionIs ,
              LinkType ,
              LinkTypeSub ,
              LinkID ,
              UserID 
            )
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @TransactionRef ,
              N'RV' ,
              @DateIs ,
              N'DS:' + @RefF ,
              @LinkType ,
              4 ,
              @ID ,
              @UserID 
            );

        SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                FROM @IDs AS s
                                ORDER BY s.ID
                             );

        INSERT @TransactionIDs
            ( ID ,
              RefF
            )
          VALUES
            ( @TransactionID ,
              CONVERT(NVARCHAR(MAX), @TransactionRef)
            );

      END;

      BEGIN --Insert detail

        SET @CID = @DeliveryChargeCurrencyID;
        SET @E = @DeliveryChargeExchangeRate;
        SET @ELL = @DeliveryChargeExchangeRateLL;
        SET @EEuro = @DeliveryChargeExchangeRateEuro;
        SET @V = @DeliveryCharge;
        SET @VD = @DeliveryChargeD;

        INSERT INTO Transactions.t_TransactionDetail
            ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro, Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
          VALUES  ( 1, @TransactionID, @BoxID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro, N'DS:' + @RefF + ' \ ' + @Customer, @CID, @E ),
                  ( 2, @TransactionID, @CustomerID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, N'DS:' + @RefF, @CID, @E );

      END;

    END;

    IF @EmployeeID <> '00000000-0000-0000-0000-000000000000'
    BEGIN
               
      IF @Expense > 0
      BEGIN --Transaction

        BEGIN --Set info

          SELECT @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
            FROM Transactions.t_Transaction AS s
            WHERE s.TypeIs = N'JV';		      

        END;

        BEGIN --Insert transaction

          SET @return = 0;

          DELETE FROM @IDs;

          INSERT INTO Transactions.t_Transaction
              ( Ref ,
                TypeIs ,
                DateIs ,
                DescriptionIs ,
                LinkType ,
                LinkTypeSub ,
                LinkID ,
                UserID
              )
            OUTPUT Inserted.ID
              INTO @IDs ( ID )
            VALUES
              ( @TransactionRef ,
                N'JV' ,
                @DateIs ,
                N'DS:' + @RefF ,
                @LinkType ,
                5 ,
                @ID ,
                @UserID 
              );

          SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                  FROM @IDs AS s
                                  ORDER BY s.ID
                               );

          INSERT @TransactionIDs
              ( ID ,
                RefF
              )
            VALUES
              ( @TransactionID ,
                CONVERT(NVARCHAR(MAX), @TransactionRef)
              );

        END;

        BEGIN --Insert detail
					
          SET @CID = @DeliveryChargeCurrencyID;
          SET @E = @DeliveryChargeExchangeRate;
          SET @ELL = @DeliveryChargeExchangeRateLL;
          SET @EEuro = @DeliveryChargeExchangeRateEuro;
          SET @V = @Expense;
          SET @VD = @ExpenseD;

          INSERT INTO Transactions.t_TransactionDetail
              ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro, Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
            VALUES  ( 1, @TransactionID, @EmployeeSalaryID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro, N'DS:' + @RefF, @CID, @E ),
                    ( 2, @TransactionID, @EmployeeID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, N'DS:' + @RefF, @CID, @E );

        END;

      END;

      IF @ExpenseStatus = 1 AND @Expense > 0
      BEGIN --Transaction

        BEGIN --Set info

          SELECT @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
            FROM Transactions.t_Transaction AS s
            WHERE s.TypeIs = N'JV';		      

        END;

        BEGIN --Insert transaction

          SET @return = 0;

          DELETE FROM @IDs;

          INSERT INTO Transactions.t_Transaction
              ( Ref ,
                TypeIs ,
                DateIs ,
                DescriptionIs ,
                LinkType ,
                LinkTypeSub ,
                LinkID ,
                UserID 
              )
            OUTPUT Inserted.ID
              INTO @IDs ( ID )
            VALUES
              ( @TransactionRef ,
                N'JV' ,
                @DateIs ,
                N'DS:' + @RefF ,
                @LinkType ,
                6 ,
                @ID ,
                @UserID 
              );

          SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                  FROM @IDs AS s
                                  ORDER BY s.ID
                               );

          INSERT @TransactionIDs
              ( ID ,
                RefF
              )
            VALUES
              ( @TransactionID ,
                CONVERT(NVARCHAR(MAX), @TransactionRef)
              );

        END;

        BEGIN --Insert detail
					
          SET @CID = @DeliveryChargeCurrencyID;
          SET @E = @DeliveryChargeExchangeRate;
          SET @ELL = @DeliveryChargeExchangeRateLL;
          SET @EEuro = @DeliveryChargeExchangeRateEuro;
          SET @V = @Expense;
          SET @VD = @ExpenseD;

          INSERT INTO Transactions.t_TransactionDetail
              ( RowNumber, TransactionID, AccountID, DateIs, Balance, BalanceD, BalanceLL, BalanceEuro, Credit, CreditD, CreditLL, CreditEuro, Debit, DebitD, DebitLL, DebitEuro, StatementIs, CurrencyID, ExchangeRate )
            VALUES  ( 1, @TransactionID, @EmployeeID, @DateIs, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, @V, @VD, @VD * @ELL, @VD * @EEuro, N'DS:' + @RefF, @CID, @E ),
                    ( 2, @TransactionID, @BoxID, @DateIs, 0 - @V, 0 - @VD, ( 0 - @VD ) * @ELL, ( 0 - @VD ) * @EEuro, @V, @VD, @VD * @ELL, @VD * @EEuro, 0, 0, 0, 0, N'DS:' + @RefF + ' \ ' + @Employee, @CID, @E );

        END;

      END;

    END;

    BEGIN --Insert t_TransactionMoving

      SET @return = -1;

      INSERT INTO Transactions.t_TransactionMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
          SELECT @UserID ,
              @TransactionID ,
              @EventInsert + s.RefF ,
              0 ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
            FROM @TransactionIDs AS s;

    END;

    BEGIN --Fix data

      UPDATE Company.t_Account
        SET StatusIs = 0 ,
            LastAction = GETDATE()
        WHERE ID IN ( @BoxID, @CustomerID, @EmployeeID, @EmployeeSalaryID, @PurchaseID, @SaleID, @VendorID ) AND StatusIs = 1;
                 
      UPDATE Transactions.t_Transaction
        SET RefF = FORMAT(Ref, 'n0') ,
            DateOnly = DateIs ,
            DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
            DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
            AccountsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t.Account AS [text()]
                                              FROM Transactions.t_TransactionDetail AS t
                                              WHERE t.TransactionID = @TransactionID
                                          FOR
                                            XML PATH('')
                                          )) ,
            BalanceD = COALESCE(( SELECT SUM(s.Balance)
                                    FROM Transactions.t_TransactionDetail AS s
                                    WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 0 AND s.Balance > 0
                                ), 0) ,
            BalanceLL = COALESCE(( SELECT SUM(s.Balance)
                                    FROM Transactions.t_TransactionDetail AS s
                                    WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 1 AND s.Balance > 0
                                 ), 0) ,
            BalanceEuro = COALESCE(( SELECT SUM(s.Balance)
                                      FROM Transactions.t_TransactionDetail AS s
                                      WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 2 AND s.Balance > 0
                                   ), 0) ,
            UserIs = Users.f_UserGetName(UserID)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @TransactionIDs AS s
                        WHERE s.ID = t_Transaction.ID );

      UPDATE Transactions.t_TransactionDetail
        SET Account = Company.f_AccountGetName(AccountID) ,
            DateOnly = DateIs ,
            DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
            DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
            Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
            CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(CurrencyID) ,
            BalanceF = Currencys.f_Format(CurrencyID, Balance) ,
            BalanceAR = Currencys.f_ToWordAR(Balance, CurrencyID, 1) ,
            BalanceEN = Currencys.f_ToWordEN(Balance, CurrencyID, 1)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @TransactionIDs AS s
                        WHERE s.ID = t_TransactionDetail.TransactionID );

    END;

    BEGIN --Fix t_Account DeliveryServices

      UPDATE Company.t_Account
        SET DeliveryServicesC = [Invoices].f_DeliveryServiceGetCountByAccountCustomerID(ID) ,
            DeliveryServicesLastDate = [Invoices].f_DeliveryServiceGetLastDateByAccountCustomerID(ID) ,
            DeliveryServicesTotal = [Invoices].[f_DeliveryServiceGetTotalByAccountCustomerID](ID) ,
            DeliveryServicesProfit = [Invoices].[f_DeliveryServiceGetProfitByAccountCustomerID](ID)
        WHERE ID = @CustomerID OR ID = @CustomerIDOld;

      UPDATE Company.t_Account
        SET DeliveryServicesTotalF = Currencys.f_Format(CurrencyID, DeliveryServicesTotal) ,
            DeliveryServicesProfitF = Currencys.f_Format(CurrencyID, DeliveryServicesProfit)
        WHERE ID = @CustomerID OR ID = @CustomerIDOld;

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
