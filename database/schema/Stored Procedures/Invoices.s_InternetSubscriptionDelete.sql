SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_InternetSubscriptionDelete] @UserID UNIQUEIDENTIFIER ,
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

      DECLARE @Return INT ,
        @CustomerID UNIQUEIDENTIFIER ,
        @InternetPackageID UNIQUEIDENTIFIER;

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

      SELECT TOP ( 1 ) @CustomerID = s.CustomerID ,
          @InternetPackageID = s.InternetPackageID
        FROM Invoices.t_InternetSubscription AS s
        WHERE s.ID = @ID
        ORDER BY s.ID;

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
          SELECT s.StartFrom ,
              0 ,
              s.PriceD ,
              s.PriceLL ,
              s.PriceEuro ,
              s.CostD ,
              s.CostLL ,
              s.CostEuro ,
              s.ProfitD ,
              s.ProfitLL ,
              s.ProfitEuro
            FROM Invoices.t_InternetSubscription AS s
            WHERE s.ID = @ID;

    END;

    BEGIN --Delete t_InternetSubscription

      SET @Return = 0;

      DELETE FROM Invoices.t_InternetSubscription
        WHERE ID = @ID;

    END;

    BEGIN --Delete t_Transaction

      DELETE FROM Transactions.t_Transaction
        WHERE LinkType = 18 AND LinkID = @ID;

    END;

    BEGIN --Fix t_InternetPackage

      UPDATE Customers.t_InternetPackage
        SET TotalSubscriptions -= 1
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
            InternetSubscriptionC = [Invoices].f_InternetSubscriptionGetCountByCustomerID(ID) ,
            InternetSubscriptionTotal = [Invoices].[f_InternetSubscriptionGetTotalByCustomerID](ID) ,
            InternetSubscriptionProfit = [Invoices].[f_InternetSubscriptionGetProfitByCustomerID](ID) ,
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
                    WHERE s.ID = @CustomerID
                 )
        UPDATE o
          SET o.InternetSubscriptionTotalF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionTotal) ,
              o.InternetSubscriptionProfitF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionProfit);

    END;

    BEGIN --Merge t_ProfitDaily

      MERGE Invoices.t_ProfitDaily AS t
      USING @ProfitTable AS s
      ON s.DateOnly = t.DateIs
      WHEN MATCHED THEN
        UPDATE SET t.SalesQtys -= 1 ,
                    t.SalesD -= s.PriceD ,
                    t.SalesLL -= s.PriceLL ,
                    t.SalesEuro -= s.PriceEuro ,
                    t.CostD -= s.CostD ,
                    t.CostLL -= s.CostLL ,
                    t.CostEuro -= s.CostEuro ,
                    t.ProfitGrossD -= s.ProfitD ,
                    t.ProfitGrossLL -= s.ProfitLL ,
                    t.ProfitGrossEuro -= s.ProfitEuro;

    END;

    BEGIN --Insert event

      SET @Return = -1;

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
            @Event ,
            2 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;












GO
