SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_ProfitDailyRebuildingStatistics]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

      DECLARE @Profit AS TABLE
        (
          DateIs DATE NOT NULL ,
          Qtys DECIMAL(18, 2) NULL ,
          SalesD FLOAT NULL ,
          SalesLL FLOAT NULL ,
          SalesEuro FLOAT NULL ,
          GymSubscriptionD FLOAT NULL ,
          GymSubscriptionLL FLOAT NULL ,
          GymSubscriptionEuro FLOAT NULL ,
          CarRentalD FLOAT NULL ,
          CarRentalLL FLOAT NULL ,
          CarRentalEuro FLOAT NULL ,
          CostD FLOAT NULL ,
          CostLL FLOAT NULL ,
          CostEuro FLOAT NULL ,
          SalesCommissionD FLOAT NULL ,
          SalesCommissionLL FLOAT NULL ,
          SalesCommissionEuro FLOAT NULL ,
          ProfitD FLOAT NULL ,
          ProfitLL FLOAT NULL ,
          ProfitEuro FLOAT NULL ,
          ExpensesD FLOAT NULL ,
          ExpensesLL FLOAT NULL ,
          ExpensesEuro FLOAT NULL ,
          SalaryD FLOAT NULL ,
          SalaryLL FLOAT NULL ,
          SalaryEuro FLOAT NULL
        );

    END;

    DISABLE TRIGGER Invoices.tr_ProfitDaily ON Invoices.t_ProfitDaily;

    BEGIN --TRUNCATE t_ProfitDaily

      TRUNCATE TABLE Invoices.t_ProfitDaily;

    END;

    BEGIN --Insert t_Sold

      SET @Return = 0;

      INSERT  INTO @Profit
              ( DateIs ,
                Qtys ,
                SalesD ,
                SalesLL ,
                SalesEuro ,
                CostD ,
                CostLL ,
                CostEuro ,
                SalesCommissionD ,
                SalesCommissionLL ,
                SalesCommissionEuro ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro
              )
      SELECT  s.DateOnly ,
              COALESCE(SUM(s.Qtys), 0) ,
              COALESCE(SUM(s.NetIsD), 0) ,
              COALESCE(SUM(s.NetIsLL), 0) ,
              COALESCE(SUM(s.NetIsEuro), 0) ,
              COALESCE(SUM(s.CostD), 0) ,
              COALESCE(SUM(s.CostLL), 0) ,
              COALESCE(SUM(s.CostEuro), 0) ,
              COALESCE(SUM(s.CommissionValueD), 0) ,
              COALESCE(SUM(s.CommissionValueLL), 0) ,
              COALESCE(SUM(s.CommissionValueEuro), 0) ,
              COALESCE(SUM(s.ProfitD), 0) ,
              COALESCE(SUM(s.ProfitLL), 0) ,
              COALESCE(SUM(s.ProfitEuro), 0)
      FROM    Invoices.t_Sold AS s
      GROUP BY s.DateOnly;

      MERGE Invoices.t_ProfitDaily AS t
      USING @Profit AS s
      ON s.DateIs = t.DateIs
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( DateIs ,
                 SalesQtys ,
                 SalesD ,
                 SalesLL ,
                 SalesEuro ,
                 CostD ,
                 CostLL ,
                 CostEuro ,
                 SalesCommissionD ,
                 SalesCommissionLL ,
                 SalesCommissionEuro ,
                 ProfitGrossD ,
                 ProfitGrossLL ,
                 ProfitGrossEuro
               )
        VALUES ( s.DateIs ,
                 s.Qtys ,
                 s.SalesD ,
                 s.SalesLL ,
                 s.SalesEuro ,
                 s.CostD ,
                 s.CostLL ,
                 s.CostEuro ,
                 s.SalesCommissionD ,
                 s.SalesCommissionLL ,
                 s.SalesCommissionEuro ,
                 s.ProfitD ,
                 s.ProfitLL ,
                 s.ProfitEuro
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.SalesQtys += s.Qtys ,
               t.SalesD += s.SalesD ,
               t.SalesLL += s.SalesLL ,
               t.SalesEuro += s.SalesEuro ,
               t.CostD += s.CostD ,
               t.CostLL += s.CostLL ,
               t.CostEuro += s.CostEuro ,
               t.SalesCommissionD += s.SalesCommissionD ,
               t.SalesCommissionLL += s.SalesCommissionLL ,
               t.SalesCommissionEuro += s.SalesCommissionEuro ,
               t.ProfitGrossD += s.ProfitD ,
               t.ProfitGrossLL += s.ProfitLL ,
               t.ProfitGrossEuro += s.ProfitEuro;

    END;
		
    BEGIN --Merge t_InternetSubscription

      DELETE  FROM @Profit;

      INSERT  INTO @Profit
              ( DateIs ,
                Qtys ,
                SalesD ,
                SalesLL ,
                SalesEuro ,
                CostD ,
                CostLL ,
                CostEuro ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro
              )
      SELECT  s.StartFrom ,
              COALESCE(COUNT(*), 0) ,
              COALESCE(SUM(s.PriceD), 0) ,
              COALESCE(SUM(s.PriceLL), 0) ,
              COALESCE(SUM(s.PriceEuro), 0) ,
              COALESCE(SUM(s.CostD), 0) ,
              COALESCE(SUM(s.CostLL), 0) ,
              COALESCE(SUM(s.CostEuro), 0) ,
              COALESCE(SUM(s.ProfitD), 0) ,
              COALESCE(SUM(s.ProfitLL), 0) ,
              COALESCE(SUM(s.ProfitEuro), 0)
      FROM    Invoices.t_InternetSubscription AS s
      GROUP BY s.StartFrom
      UNION ALL
      SELECT  s.StartFrom ,
              COALESCE(COUNT(*), 0) ,
              COALESCE(SUM(s.PriceD), 0) ,
              COALESCE(SUM(s.PriceLL), 0) ,
              COALESCE(SUM(s.PriceEuro), 0) ,
              COALESCE(SUM(s.CostD), 0) ,
              COALESCE(SUM(s.CostLL), 0) ,
              COALESCE(SUM(s.CostEuro), 0) ,
              COALESCE(SUM(s.ProfitD), 0) ,
              COALESCE(SUM(s.ProfitLL), 0) ,
              COALESCE(SUM(s.ProfitEuro), 0)
      FROM    Invoices.t_InternetSubscriptionHistory AS s
      GROUP BY s.StartFrom;

      MERGE Invoices.t_ProfitDaily AS t
      USING @Profit AS s
      ON s.DateIs = t.DateIs
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
        VALUES ( s.DateIs ,
                 s.Qtys ,
                 s.SalesD ,
                 s.SalesLL ,
                 s.SalesEuro ,
                 s.CostD ,
                 s.CostLL ,
                 s.CostEuro ,
                 s.ProfitD ,
                 s.ProfitLL ,
                 s.ProfitEuro
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.SalesQtys += s.Qtys ,
               t.SalesD += s.SalesD ,
               t.SalesLL += s.SalesLL ,
               t.SalesEuro += s.SalesEuro ,
               t.CostD += s.CostD ,
               t.CostLL += s.CostLL ,
               t.CostEuro += s.CostEuro ,
               t.ProfitGrossD += s.ProfitD ,
               t.ProfitGrossLL += s.ProfitLL ,
               t.ProfitGrossEuro += s.ProfitEuro;

    END;

    BEGIN --Merge t_DeliveryService

      DELETE  FROM @Profit;

      INSERT  INTO @Profit
              ( DateIs ,
                Qtys ,
                SalesD ,
                SalesLL ,
                SalesEuro 
              )
      SELECT  s.DateOnly ,
              COALESCE(COUNT(*), 0) ,
              COALESCE(SUM(s.DeliveryChargeD), 0) ,
              COALESCE(SUM(s.DeliveryChargeLL), 0) ,
              COALESCE(SUM(s.DeliveryChargeEuro), 0)
      FROM    Invoices.t_DeliveryService AS s
      WHERE   s.StatusIs <> 5
      GROUP BY s.DateOnly
      UNION ALL
      SELECT  s.DateOnly ,
              COALESCE(COUNT(*), 0) ,
              COALESCE(SUM(s.DeliveryChargeD), 0) ,
              COALESCE(SUM(s.DeliveryChargeLL), 0) ,
              COALESCE(SUM(s.DeliveryChargeEuro), 0)
      FROM    Invoices.t_DeliveryServiceHistory AS s
      WHERE   s.StatusIs <> 5
      GROUP BY s.DateOnly;

      MERGE Invoices.t_ProfitDaily AS t
      USING @Profit AS s
      ON s.DateIs = t.DateIs
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( DateIs ,
                 SalesQtys ,
                 SalesD ,
                 SalesLL ,
                 SalesEuro ,
                 ProfitGrossD ,
                 ProfitGrossLL ,
                 ProfitGrossEuro
               )
        VALUES ( s.DateIs ,
                 s.Qtys ,
                 s.SalesD ,
                 s.SalesLL ,
                 s.SalesEuro ,
                 s.SalesD ,
                 s.SalesLL ,
                 s.SalesEuro
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.SalesQtys += s.Qtys ,
               t.SalesD += s.SalesD ,
               t.SalesLL += s.SalesLL ,
               t.SalesEuro += s.SalesEuro ,
               t.ProfitGrossD += s.SalesD ,
               t.ProfitGrossLL += s.SalesLL ,
               t.ProfitGrossEuro += s.SalesEuro;

    END;

    BEGIN --Merge t_GymSubscription.

      DELETE  FROM @Profit;

      INSERT  INTO @Profit
              ( DateIs ,
                GymSubscriptionD ,
                GymSubscriptionLL ,
                GymSubscriptionEuro 
              )
      SELECT  o.DateIs ,
              SUM(o.TotalD) ,
              SUM(o.TotalLL) ,
              SUM(o.TotalEuro)
      FROM    ( SELECT  s.DateIs ,
                        COALESCE(SUM(s.TotalD), 0) AS TotalD ,
                        COALESCE(SUM(s.TotalLL), 0) AS TotalLL ,
                        COALESCE(SUM(s.TotalEuro), 0) AS TotalEuro
                FROM    Gym.t_GymSubscription AS s
                GROUP BY s.DateIs
                UNION ALL
                SELECT  s.DateIs ,
                        COALESCE(SUM(s.TotalD), 0) AS TotalD ,
                        COALESCE(SUM(s.TotalLL), 0) AS TotalLL ,
                        COALESCE(SUM(s.TotalEuro), 0) AS TotalEuro
                FROM    Gym.t_GymSubscriptionHistory AS s
                GROUP BY s.DateIs
              ) AS o
      GROUP BY o.DateIs;

      MERGE Invoices.t_ProfitDaily AS t
      USING @Profit AS s
      ON s.DateIs = t.DateIs
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( DateIs ,
                 GymSubscriptionD ,
                 GymSubscriptionLL ,
                 GymSubscriptionEuro ,
                 ProfitGrossD ,
                 ProfitGrossLL ,
                 ProfitGrossEuro
               )
        VALUES ( s.DateIs ,
                 s.GymSubscriptionD ,
                 s.GymSubscriptionLL ,
                 s.GymSubscriptionEuro ,
                 s.GymSubscriptionD ,
                 s.GymSubscriptionLL ,
                 s.GymSubscriptionEuro
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.GymSubscriptionD += s.GymSubscriptionD ,
               t.GymSubscriptionLL += s.GymSubscriptionLL ,
               t.GymSubscriptionEuro += s.GymSubscriptionEuro ,
               t.ProfitGrossD += s.GymSubscriptionD ,
               t.ProfitGrossLL += s.GymSubscriptionLL ,
               t.ProfitGrossEuro += s.GymSubscriptionEuro;

    END;

    BEGIN --Merge t_CarRental.

      DELETE  FROM @Profit;

      INSERT  INTO @Profit
              ( DateIs ,
                CarRentalD ,
                CarRentalLL ,
                CarRentalEuro 
              )
      SELECT  o.AgreementDate ,
              SUM(o.TotalD) ,
              SUM(o.TotalLL) ,
              SUM(o.TotalEuro)
      FROM    ( SELECT  s.AgreementDate ,
                        COALESCE(SUM(s.TotalD), 0) AS TotalD ,
                        COALESCE(SUM(s.TotalLL), 0) AS TotalLL ,
                        COALESCE(SUM(s.TotalEuro), 0) AS TotalEuro
                FROM    Cars.t_CarRental AS s
                GROUP BY s.AgreementDate
                UNION ALL
                SELECT  s.AgreementDate ,
                        COALESCE(SUM(s.TotalD), 0) AS TotalD ,
                        COALESCE(SUM(s.TotalLL), 0) AS TotalLL ,
                        COALESCE(SUM(s.TotalEuro), 0) AS TotalEuro
                FROM    Cars.t_CarRentalHistory AS s
				WHERE s.StatusIs <> 3
                GROUP BY s.AgreementDate
              ) AS o
      GROUP BY o.AgreementDate;

      MERGE Invoices.t_ProfitDaily AS t
      USING @Profit AS s
      ON s.DateIs = t.DateIs
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( DateIs ,
                 CarRentalD ,
                 CarRentalLL ,
                 CarRentalEuro ,
                 ProfitGrossD ,
                 ProfitGrossLL ,
                 ProfitGrossEuro
               )
        VALUES ( s.DateIs ,
                 s.CarRentalD ,
                 s.CarRentalLL ,
                 s.CarRentalEuro ,
                 s.CarRentalD ,
                 s.CarRentalLL ,
                 s.CarRentalEuro
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.CarRentalD += s.CarRentalD ,
               t.CarRentalLL += s.CarRentalLL ,
               t.CarRentalEuro += s.CarRentalEuro ,
               t.ProfitGrossD += s.CarRentalD ,
               t.ProfitGrossLL += s.CarRentalLL ,
               t.ProfitGrossEuro += s.CarRentalEuro;

    END;

    BEGIN --Merge t_SoldReturn

      DELETE  FROM @Profit;

      INSERT  INTO @Profit
              ( DateIs ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro
              )
      SELECT  s.DateOnly ,
              COALESCE(SUM(s.ProfitD), 0) ,
              COALESCE(SUM(s.ProfitLL), 0) ,
              COALESCE(SUM(s.ProfitEuro), 0)
      FROM    Invoices.t_SoldReturn AS s
      GROUP BY s.DateOnly;

      MERGE Invoices.t_ProfitDaily AS t
      USING @Profit AS s
      ON s.DateIs = t.DateIs
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( DateIs ,
                 ProfitSalesRefundD ,
                 ProfitSalesRefundLL ,
                 ProfitSalesRefundEuro
               )
        VALUES ( s.DateIs ,
                 s.ProfitD ,
                 s.ProfitLL ,
                 s.ProfitEuro
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.ProfitSalesRefundD += s.ProfitD ,
               t.ProfitSalesRefundLL += s.ProfitLL ,
               t.ProfitSalesRefundEuro += s.ProfitEuro;

    END;

    BEGIN --Merge Expenses t_TransactionDetail

      DELETE  FROM @Profit;

      INSERT  INTO @Profit
              ( DateIs ,
                ExpensesD ,
                ExpensesLL ,
                ExpensesEuro
              )
      SELECT  s.DateOnly ,
              COALESCE(SUM(s.BalanceD), 0) ,
              COALESCE(SUM(s.BalanceLL), 0) ,
              COALESCE(SUM(s.BalanceEuro), 0)
      FROM    Transactions.t_TransactionDetail AS s
      LEFT JOIN Company.t_Account AS s1 ON s1.ID = s.AccountID
      WHERE   s1.NumberIs BETWEEN 6260400000 AND 6269999999
      GROUP BY s.DateOnly;

      MERGE Invoices.t_ProfitDaily AS t
      USING @Profit AS s
      ON s.DateIs = t.DateIs
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( DateIs ,
                 ExpensesD ,
                 ExpensesLL ,
                 ExpensesEuro
               )
        VALUES ( s.DateIs ,
                 s.ExpensesD ,
                 s.ExpensesLL ,
                 s.ExpensesEuro
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.ExpensesD += s.ExpensesD ,
               t.ExpensesLL += s.ExpensesLL ,
               t.ExpensesEuro += s.ExpensesEuro;

    END;
          
    BEGIN --Merge Salary t_TransactionDetail

      DELETE  FROM @Profit;

      INSERT  INTO @Profit
              ( DateIs ,
                SalaryD ,
                SalaryLL ,
                SalaryEuro
              )
      SELECT  s.DateOnly ,
              COALESCE(SUM(s.BalanceD), 0) ,
              COALESCE(SUM(s.BalanceLL), 0) ,
              COALESCE(SUM(s.BalanceEuro), 0)
      FROM    Transactions.t_TransactionDetail AS s
      LEFT JOIN Company.t_Account AS s1 ON s1.ID = s.AccountID
      WHERE   s1.NumberIs BETWEEN 6310100000 AND 6310199999
      GROUP BY s.DateOnly;

      MERGE Invoices.t_ProfitDaily AS t
      USING @Profit AS s
      ON s.DateIs = t.DateIs
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( DateIs ,
                 SalaryD ,
                 SalaryLL ,
                 SalaryEuro
               )
        VALUES ( s.DateIs ,
                 s.SalaryD ,
                 s.SalaryLL ,
                 s.SalaryEuro
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.SalaryD += s.SalaryD ,
               t.SalaryLL += s.SalaryLL ,
               t.SalaryEuro += s.SalaryEuro;

    END;

    BEGIN --Format

      UPDATE  Invoices.t_ProfitDaily
      SET     DateMonthly = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
              DateYearly = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
              ProfitNetD = ProfitGrossD - ProfitSalesRefundD - ExpensesD - SalaryD - SalesCommissionD ,
              ProfitNetLL = ProfitGrossLL - ProfitSalesRefundLL - ExpensesLL - SalaryLL - SalesCommissionLL ,
              ProfitNetEuro = ProfitGrossEuro - ProfitSalesRefundEuro - ExpensesEuro - SalaryEuro - SalesCommissionEuro ,
              ProfitNetRate = 0;

      UPDATE  Invoices.t_ProfitDaily
      SET     ProfitNetRate = ( ProfitNetD / SalesD ) * 100.0
      WHERE   SalesD > 0;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Invoices.t_SoldMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                '00000000-0000-0000-0000-000000000000' ,
                @Event ,
                6 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    ENABLE TRIGGER Invoices.tr_ProfitDaily ON Invoices.t_ProfitDaily;

    COMMIT TRAN;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;






GO
