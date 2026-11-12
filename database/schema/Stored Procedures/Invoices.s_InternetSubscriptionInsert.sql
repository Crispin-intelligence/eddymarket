SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_InternetSubscriptionInsert] @DateIs DATETIME ,
  @StartFrom DATE ,
  @ActiveTo DATE ,
  @CustomerID UNIQUEIDENTIFIER ,
  @AccountSaleID UNIQUEIDENTIFIER ,
  @AccountBoxID UNIQUEIDENTIFIER ,
  @InternetPackageID UNIQUEIDENTIFIER ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @ExchangeRate DECIMAL(18, 2) ,
  @Cost FLOAT ,
  @Price FLOAT ,
  @Paid FLOAT ,
  @RestIs FLOAT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @TransactionJV Transactions.dt_TransactionDetailShort READONLY ,
  @TransactionRV Transactions.dt_TransactionDetailShort READONLY ,
  @TransactionJVDescriptionIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
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

      DECLARE @Ref BIGINT ,
        @RefJV BIGINT ,
        @RefRV BIGINT ,
        @TransactionID UNIQUEIDENTIFIER ,
        @Currency NVARCHAR(MAX) ,
        @ExchangeRateLL DECIMAL(18, 2) ,
        @ExchangeRateEuro DECIMAL(18, 2) ,
        @CurrencyTypeIs INT ,
        @CurrencyTypeIsAccountCustomer INT ,
        @CostD FLOAT ,
        @PriceD FLOAT ,
        @Profit FLOAT ,
        @ProfitD FLOAT ,
        @PaidD FLOAT ,
        @RestIsD FLOAT ,
        @ProfitCollected FLOAT ,
        @ProfitCollectedD FLOAT ,
        @return INT;

      DECLARE @ProfitTable AS TABLE
        (
          DateOnly DATE NOT NULL ,
          Qtys DECIMAL(18, 2) NULL ,
          PriceD FLOAT NULL ,
          PriceLL FLOAT NULL ,
          PriceEuro FLOAT NULL ,
          CostD FLOAT NULL ,
          CostLL FLOAT NULL ,
          CostEuro FLOAT NULL ,
          ProfitD FLOAT NULL ,
          ProfitLL FLOAT NULL ,
          ProfitEuro FLOAT NULL
        );

    END;

    BEGIN --Set info

      SELECT @Ref = ISNULL(MAX(s.Ref), 0) + 1
        FROM ( SELECT s1.Ref
                FROM Invoices.t_InternetSubscription AS s1
               UNION ALL
               SELECT s1.Ref
                FROM Invoices.t_InternetSubscriptionHistory AS s1
             ) AS s;

      SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);
      SET @ExchangeRateLL = Currencys.f_CurrencyGetExchangeRateLL();
      SET @ExchangeRateEuro = Currencys.f_CurrencyGetExchangeRateEuro();
      SET @CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID);

      SELECT TOP ( 1 ) @CurrencyTypeIsAccountCustomer = s.CurrencyTypeIs
        FROM Company.t_Account AS s
        WHERE s.LinkWithID = @CustomerID AND s.IsMasterLink = 1 AND s.SectionID = 15
        ORDER BY s.ID;
		
      SET @CostD = @Cost / @ExchangeRate;
				
      SET @PriceD = @Price / @ExchangeRate;

      SET @Profit = @Price - @Cost;
				
      SET @ProfitD = @Profit / @ExchangeRate;
				
      SET @PaidD = @Paid / @ExchangeRate;

      SET @RestIsD = @Paid / @ExchangeRate;

      SET @ProfitCollected = @Profit - @RestIs;
				
      SET @ProfitCollectedD = @ProfitCollected / @ExchangeRate;

      INSERT INTO @ProfitTable
          ( DateOnly ,
            Qtys ,
            PriceD ,
            PriceLL ,
            PriceEuro ,
            CostD ,
            CostLL ,
            CostEuro ,
            ProfitD ,
            ProfitLL ,
            ProfitEuro
				
          )
        VALUES
          ( @StartFrom ,
            1 ,
            @PriceD ,
            @PriceD * @ExchangeRateLL ,
            @PriceD * @ExchangeRateEuro ,
            @CostD ,
            @CostD * @ExchangeRateLL ,
            @CostD * @ExchangeRateEuro ,
            @ProfitD ,
            @ProfitD * @ExchangeRateLL ,
            @ProfitD * @ExchangeRateEuro
          );

    END;

    BEGIN --Insert

      SET @return = 0;

      INSERT INTO Invoices.t_InternetSubscription
          ( Ref ,
            RefF ,
            DateIs ,
            DateOnly ,
            DateMonthly ,
            DateYearly ,
            StartFrom ,
            ActiveTo ,
            CustomerID ,
            Customer ,
            AccountSaleID ,
            AccountSale ,
            AccountSaleNumberF ,
            AccountBoxID ,
            AccountBox ,
            AccountBoxNumberF ,
            InternetPackageID ,
            InternetPackage ,
            CurrencyID ,
            Currency ,
            ExchangeRate ,
            Cost ,
            CostF ,
            CostD ,
            CostLL ,
            CostEuro ,
            Price ,
            PriceF ,
            PriceD ,
            PriceLL ,
            PriceEuro ,
            PriceAR ,
            PriceEN ,
            Profit ,
            ProfitF ,
            ProfitD ,
            ProfitLL ,
            ProfitEuro ,
            Paid ,
            PaidF ,
            PaidD ,
            PaidLL ,
            PaidEuro ,
            RestIs ,
            RestIsF ,
            RestIsD ,
            RestIsLL ,
            RestIsEuro ,
            ProfitCollected ,
            ProfitCollectedF ,
            ProfitCollectedD ,
            ProfitCollectedLL ,
            ProfitCollectedEuro ,
            PatmentStatus ,
            DescriptionIs
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Ref ,
            FORMAT(@Ref, 'n0') ,
            @DateIs ,
            @DateIs ,
            DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
            DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
            @StartFrom ,
            @ActiveTo ,
            @CustomerID ,
            Customers.f_CustomerGetName(@CustomerID) ,
            @AccountSaleID ,
            Company.f_AccountGetName(@AccountSaleID) ,
            Company.f_AccountGetNumberF(@AccountSaleID) ,
            @AccountBoxID ,
            Company.f_AccountGetName(@AccountBoxID) ,
            Company.f_AccountGetNumberF(@AccountBoxID) ,
            @InternetPackageID ,
            Customers.f_InternetPackageGetName(@InternetPackageID) ,
            @CurrencyID ,
            @Currency ,
            @ExchangeRate ,
            @Cost ,
            Currencys.f_Format(@CurrencyID, @Cost) ,
            @CostD ,
            @CostD * @ExchangeRateLL ,
            @CostD * @ExchangeRateEuro ,
            @Price ,
            Currencys.f_Format(@CurrencyID, @Price) ,
            @PriceD ,
            @PriceD * @ExchangeRateLL ,
            @PriceD * @ExchangeRateEuro ,
            Currencys.f_ToWordAR(@Price, @CurrencyID, 1) ,
            Currencys.f_ToWordEN(@Price, @CurrencyID, 1) ,
            @Profit ,
            Currencys.f_Format(@CurrencyID, @Profit) ,
            @ProfitD ,
            @ProfitD * @ExchangeRateLL ,
            @ProfitD * @ExchangeRateEuro ,
            @Paid ,
            Currencys.f_Format(@CurrencyID, @Paid) ,
            @PaidD ,
            @PaidD * @ExchangeRateLL ,
            @PaidD * @ExchangeRateEuro ,
            @RestIs ,
            Currencys.f_Format(@CurrencyID, @RestIs) ,
            @RestIsD ,
            @RestIsD * @ExchangeRateLL ,
            @RestIsD * @ExchangeRateEuro ,
            @ProfitCollected ,
            Currencys.f_Format(@CurrencyID, @ProfitCollected) ,
            @ProfitCollectedD ,
            @ProfitCollectedD * @ExchangeRateLL ,
            @ProfitCollectedD * @ExchangeRateEuro ,
            IIF(@Paid = 0, 0, IIF(@Paid < @Price, 1, 2)) ,
            @DescriptionIs
          );

      SET @ID = ( SELECT TOP ( 1 ) s.ID
                    FROM @IDs AS s
                    ORDER BY s.ID
                );

    END;

    BEGIN --Fix t_InternetPackage

      UPDATE Customers.t_InternetPackage
        SET TotalSubscriptions += 1
        WHERE ID = @InternetPackageID;

    END;

    BEGIN --Fix t_Customer

      UPDATE Customers.t_Customer
        SET ActiveToInternet = COALESCE(( SELECT MAX(s.ActiveTo)
                                            FROM ( SELECT s1.ActiveTo ,
                                                      s1.CustomerID
                                                    FROM Invoices.t_InternetSubscription AS s1
                                                   UNION ALL
                                                   SELECT s1.ActiveTo ,
                                                      s1.CustomerID
                                                    FROM Invoices.t_InternetSubscriptionHistory AS s1
                                                 ) AS s
                                            WHERE s.CustomerID = t_Customer.ID
                                        ), StartFromInternet) ,
            InternetSubscriptionC += 1 ,
            InternetSubscriptionTotal = CASE @CurrencyTypeIsAccountCustomer
                                          WHEN 0 THEN @PriceD
                                          WHEN 1 THEN @PriceD * @ExchangeRateLL
                                          ELSE @PriceD * @ExchangeRateEuro
                                        END ,
            InternetSubscriptionProfit = CASE @CurrencyTypeIsAccountCustomer
                                           WHEN 0 THEN @ProfitD
                                           WHEN 1 THEN @ProfitD * @ExchangeRateLL
                                           ELSE @ProfitD * @ExchangeRateEuro
                                         END ,
            InternetSubscriptionLast = [Invoices].f_InternetSubscriptionGetLastDateByCustomerID(ID)
        WHERE ID = @CustomerID;

      UPDATE Customers.t_Customer
        SET NotificationDateInternet = DATEADD(DAY, 0 - NotificationBeforeDaysInternet, ActiveToInternet) ,
            ActiveToDayInternet = DAY(ActiveToInternet)
        WHERE ID = @CustomerID;

      WITH  o AS ( SELECT s1.CurrencyID ,
                      s.InternetSubscriptionTotal ,
                      s.InternetSubscriptionTotalF ,
                      s.InternetSubscriptionProfit ,
                      s.InternetSubscriptionProfitF
                    FROM Customers.t_Customer AS s
                      INNER JOIN Company.t_Account AS s1 ON s1.LinkWithID = s.ID AND s1.IsMasterLink = 1 AND s1.SectionID = 15
                    WHERE s.ID = @ID
                 )
        UPDATE o
          SET o.InternetSubscriptionTotalF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionTotal) ,
              o.InternetSubscriptionProfitF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionProfit);

    END;

    BEGIN --Merge t_ProfitDaily

      MERGE Invoices.t_ProfitDaily AS t
      USING @ProfitTable AS s
      ON s.DateOnly = t.DateIs
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( DateIs ,
                 SalesQtys ,
                 SalesD ,
                 SalesLL ,
                 SalesEuro ,
                 CostD ,
                 CostLL ,
                 CostEuro ,
                 ProfitGrossD ,
                 ProfitGrossLL ,
                 ProfitGrossEuro
               )
        VALUES ( s.DateOnly ,
                 s.Qtys ,
                 s.PriceD ,
                 s.PriceLL ,
                 s.PriceEuro ,
                 s.CostD ,
                 s.CostLL ,
                 s.CostEuro ,
                 s.ProfitD ,
                 s.ProfitLL ,
                 s.ProfitEuro
               )
      WHEN MATCHED THEN
        UPDATE SET t.SalesQtys += s.Qtys ,
                    t.SalesD += s.PriceD ,
                    t.SalesLL += s.PriceLL ,
                    t.SalesEuro += s.PriceEuro ,
                    t.CostD += s.CostD ,
                    t.CostLL += s.CostLL ,
                    t.CostEuro += s.CostEuro ,
                    t.ProfitGrossD += s.ProfitD ,
                    t.ProfitGrossLL += s.ProfitLL ,
                    t.ProfitGrossEuro += s.ProfitEuro;

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Invoices.t_InternetSubscriptionMoving
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
            @Event + CONVERT(NVARCHAR(MAX), @Ref) ,
            0 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    IF @Price > 0
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
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @RefJV ,
              FORMAT(@RefJV, 'n0') ,
              N'JV' ,
              @DateIs ,
              @DateIs ,
              DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
              DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
              REPLACE(@TransactionJVDescriptionIs, N'{0}', @Ref) ,
              Alls.f_FixXML(( SELECT DISTINCT ', ' + t1.Name AS [text()]
                                FROM @TransactionJV AS t
                                  LEFT JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
                            FOR
                              XML PATH('')
                            )) ,
              18 ,
              @ID ,
              @UserID ,
              Users.f_UserGetName(@UserID)
            );

        SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                FROM @IDs AS s
                                ORDER BY s.ID
                             );

      END;

      BEGIN --Insert detail

        INSERT INTO Transactions.t_TransactionDetail
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
            SELECT o.RowNumber ,
                @TransactionID ,
                o.AccountID ,
                o.Account ,
                @DateIs ,
                @DateIs ,
                DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
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
              FROM ( SELECT t.RowNumber ,
                        t.AccountID ,
                        Company.f_AccountGetName(t.AccountID) AS Account ,
                        t.Balance ,
                        Currencys.f_Format(@CurrencyID, t.Balance) AS BalanceF ,
                        t.Balance / @ExchangeRate AS BalanceD ,
                        ( t.Balance / @ExchangeRate ) * @ExchangeRateLL AS BalanceLL ,
                        ( t.Balance / @ExchangeRate ) * @ExchangeRateEuro AS BalanceEuro ,
                        Currencys.f_ToWordAR(Balance, @CurrencyID, 1) AS BalanceAR ,
                        Currencys.f_ToWordEN(Balance, @CurrencyID, 1) AS BalanceEN ,
                        IIF(Balance < 0, Balance, 0) AS Credit ,
                        IIF(Balance > 0, Balance, 0) AS Debit ,
                        REPLACE(t.StatementIs, N'{0}', @Ref) AS StatementIs
                      FROM @TransactionJV AS t
                   ) AS o
              ORDER BY o.RowNumber;

      END;

      BEGIN --Fix data

        UPDATE Company.t_Account
          SET StatusIs = 0 ,
              LastAction = GETDATE()
          WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                          FROM @TransactionJV AS s
                          WHERE s.AccountID = t_Account.ID ) AND StatusIs = 1;

      END;

      BEGIN --Fix data

        UPDATE Transactions.t_Transaction
          SET BalanceD = COALESCE(( SELECT SUM(s.Balance)
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
                                     ), 0)
          WHERE ID = @TransactionID;

      END;

      BEGIN --Insert event

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
          VALUES
            ( @UserID ,
              @TransactionID ,
              @Event + CONVERT(NVARCHAR(MAX), @RefJV) ,
              0 ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
            );

      END;

    END;

    IF @Paid > 0
    BEGIN --Transaction

      BEGIN --Set info

        SELECT @RefRV = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = N'RV';

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE FROM @IDs;

        INSERT INTO Transactions.t_Transaction
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
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @RefRV ,
              FORMAT(@RefRV, 'n0') ,
              N'RV' ,
              @DateIs ,
              @DateIs ,
              DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
              DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
              REPLACE(@TransactionJVDescriptionIs, N'{0}', @Ref) ,
              Alls.f_FixXML(( SELECT DISTINCT ', ' + t1.Name AS [text()]
                                FROM @TransactionRV AS t
                                  LEFT JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
                            FOR
                              XML PATH('')
                            )) ,
              18 ,
              @ID ,
              @UserID ,
              Users.f_UserGetName(@UserID)
            );

        SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                FROM @IDs AS s
                                ORDER BY s.ID
                             );

      END;

      BEGIN --Insert detail

        INSERT INTO Transactions.t_TransactionDetail
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
            SELECT o.RowNumber ,
                @TransactionID ,
                o.AccountID ,
                o.Account ,
                @DateIs ,
                @DateIs ,
                DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
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
              FROM ( SELECT t.RowNumber ,
                        t.AccountID ,
                        Company.f_AccountGetName(t.AccountID) AS Account ,
                        t.Balance ,
                        Currencys.f_Format(@CurrencyID, t.Balance) AS BalanceF ,
                        t.Balance / @ExchangeRate AS BalanceD ,
                        ( t.Balance / @ExchangeRate ) * @ExchangeRateLL AS BalanceLL ,
                        ( t.Balance / @ExchangeRate ) * @ExchangeRateEuro AS BalanceEuro ,
                        Currencys.f_ToWordAR(Balance, @CurrencyID, 1) AS BalanceAR ,
                        Currencys.f_ToWordEN(Balance, @CurrencyID, 1) AS BalanceEN ,
                        IIF(Balance < 0, Balance, 0) AS Credit ,
                        IIF(Balance > 0, Balance, 0) AS Debit ,
                        REPLACE(t.StatementIs, N'{0}', @Ref) AS StatementIs
                      FROM @TransactionRV AS t
                   ) AS o
              ORDER BY o.RowNumber;

      END;

      BEGIN --Fix data

        UPDATE Company.t_Account
          SET StatusIs = 0 ,
              LastAction = GETDATE()
          WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                          FROM @TransactionRV AS s
                          WHERE s.AccountID = t_Account.ID ) AND StatusIs = 1;

      END;

      BEGIN --Fix data

        UPDATE Transactions.t_Transaction
          SET BalanceD = COALESCE(( SELECT SUM(s.Balance)
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
                                     ), 0)
          WHERE ID = @TransactionID;

      END;

      BEGIN --Insert event

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
          VALUES
            ( @UserID ,
              @TransactionID ,
              @Event + CONVERT(NVARCHAR(MAX), @RefRV) ,
              0 ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
            );

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
