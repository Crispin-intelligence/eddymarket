SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_FrameJobOrderDelete] @StatesIs TINYINT ,
  @WhyCanceled NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @CustomerID UNIQUEIDENTIFIER ,
        @Return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 ) @CustomerID = s.CustomerID
        FROM Customers.t_FrameJobOrder AS s
        WHERE s.ID = @ID
        ORDER BY s.ID;

    END;

    BEGIN --Insert t_FrameJobOrderHistory

      SET @Return = 0;

      INSERT INTO Customers.t_FrameJobOrderHistory
          ( ID ,
            Ref ,
            RefF ,
            RefPaper ,
            DateIs ,
            DateDelivery ,
            DateInProcess ,
            DateInProcessNotification ,
            DateReady ,
            DateReadyNotification ,
            StatusIs ,
            PriorityLevel ,
            CustomerID ,
            Customer ,
            DoctorID ,
            Doctor ,
            SalespersonID ,
            Salesperson ,
            StatesID ,
            StatesIs ,
            RegionID ,
            RegionIs ,
            StreetID ,
            Street ,
            AddressIs ,
            Focal ,
            WithRight ,
            WithLeft ,
            SphereRight ,
            SphereLeft ,
            CylinderRight ,
            CylinderLeft ,
            AxisRight ,
            AxisLeft ,
            PrismRight ,
            PrismLeft ,
            BaseRight ,
            BaseLeft ,
            Addition ,
            HeightRight ,
            HeightLeft ,
            PDRight ,
            PDLeft ,
            PD ,
            CurrencyID ,
            Currency ,
            ExchangeRate ,
            ExchangeRateLL ,
            ExchangeRateEuro ,
            SubTotal ,
            SubTotalF ,
            SubTotalD ,
            SubTotalLL ,
            SubTotalEuro ,
            DiscountIs ,
            DiscountIsF ,
            DiscountIsD ,
            DiscountIsLL ,
            DiscountIsEuro ,
            TaxRate ,
            TaxRateF ,
            TaxValue ,
            TaxValueF ,
            TaxValueD ,
            TaxValueLL ,
            TaxValueEuro ,
            Total ,
            TotalF ,
            TotalD ,
            TotalLL ,
            TotalEuro ,
            Cost ,
            CostF ,
            CostD ,
            CostLL ,
            CostEuro ,
            Profit ,
            ProfitF ,
            ProfitD ,
            ProfitLL ,
            ProfitEuro ,
            Qtys ,
            DescriptionIs ,
            WhyCanceled ,
            SoldID ,
            SoldRefF ,
            ItemsNames ,
            DateCreate ,
            IsSync ,
            WorkStationID
          )
          SELECT t.ID ,
              t.Ref ,
              t.RefF ,
              t.RefPaper ,
              t.DateIs ,
              t.DateDelivery ,
              t.DateInProcess ,
              t.DateInProcessNotification ,
              t.DateReady ,
              t.DateReadyNotification ,
              @StatesIs ,
              t.PriorityLevel ,
              t.CustomerID ,
              t.Customer ,
              t.DoctorID ,
              t.Doctor ,
              t.SalespersonID ,
              t.Salesperson ,
              t.StatesID ,
              t.StatesIs ,
              t.RegionID ,
              t.RegionIs ,
              t.StreetID ,
              t.Street ,
              t.AddressIs ,
              t.Focal ,
              t.WithRight ,
              t.WithLeft ,
              t.SphereRight ,
              t.SphereLeft ,
              t.CylinderRight ,
              t.CylinderLeft ,
              t.AxisRight ,
              t.AxisLeft ,
              t.PrismRight ,
              t.PrismLeft ,
              t.BaseRight ,
              t.BaseLeft ,
              t.Addition ,
              t.HeightRight ,
              t.HeightLeft ,
              t.PDRight ,
              t.PDLeft ,
              t.PD ,
              t.CurrencyID ,
              t.Currency ,
              t.ExchangeRate ,
              t.ExchangeRateLL ,
              t.ExchangeRateEuro ,
              t.SubTotal ,
              t.SubTotalF ,
              t.SubTotalD ,
              t.SubTotalLL ,
              t.SubTotalEuro ,
              t.DiscountIs ,
              t.DiscountIsF ,
              t.DiscountIsD ,
              t.DiscountIsLL ,
              t.DiscountIsEuro ,
              t.TaxRate ,
              t.TaxRateF ,
              t.TaxValue ,
              t.TaxValueF ,
              t.TaxValueD ,
              t.TaxValueLL ,
              t.TaxValueEuro ,
              t.Total ,
              t.TotalF ,
              t.TotalD ,
              t.TotalLL ,
              t.TotalEuro ,
              t.Cost ,
              t.CostF ,
              t.CostD ,
              t.CostLL ,
              t.CostEuro ,
              t.Profit ,
              t.ProfitF ,
              t.ProfitD ,
              t.ProfitLL ,
              t.ProfitEuro ,
              t.Qtys ,
              t.DescriptionIs ,
              @WhyCanceled ,
              t.SoldID ,
              t.SoldRefF ,
              t.ItemsNames ,
              t.DateCreate ,
              0 ,
              t.WorkStationID
            FROM Customers.t_FrameJobOrder AS t
            WHERE t.ID = @ID;

      INSERT Customers.t_FrameJobOrderHistoryDetail
          ( ID ,
            FrameJobOrderHistoryID ,
            ItemSharedID ,
            ItemID ,
            ItemUnityID ,
            Qty ,
            QtyWithUnity ,
            Qtys ,
            ItemType ,
            Sale ,
            SaleF ,
            SaleD ,
            SaleLL ,
            SaleEuro ,
            DiscountIs ,
            DiscountIsF ,
            DiscountIsValue ,
            DiscountIsValueF ,
            DiscountIsValueD ,
            DiscountIsValueLL ,
            DiscountIsValueEuro ,
            SubTotal ,
            SubTotalF ,
            SubTotalD ,
            SubTotalLL ,
            SubTotalEuro ,
            DiscountOrder ,
            DiscountOrderF ,
            DiscountOrderD ,
            DiscountOrderLL ,
            DiscountOrderEuro ,
            TaxRate ,
            TaxRateF ,
            TaxValue ,
            TaxValueF ,
            TaxValueD ,
            TaxValueLL ,
            TaxValueEuro ,
            Total ,
            TotalF ,
            TotalD ,
            TotalLL ,
            TotalEuro ,
            Cost ,
            CostF ,
            CostD ,
            CostLL ,
            CostEuro ,
            TotalCost ,
            TotalCostF ,
            TotalCostD ,
            TotalCostLL ,
            TotalCostEuro ,
            Profit ,
            ProfitF ,
            ProfitD ,
            ProfitLL ,
            ProfitEuro ,
            ProfitTotal ,
            ProfitTotalF ,
            ProfitTotalD ,
            ProfitTotalLL ,
            ProfitTotalEuro ,
            DescriptionIs ,
            SortAt ,
            DateCreate ,
            IsSync ,
            WorkStationID
          )
          SELECT t.ID ,
              t.FrameJobOrderID ,
              t.ItemSharedID ,
              t.ItemID ,
              t.ItemUnityID ,
              t.Qty ,
              t.QtyWithUnity ,
              t.Qtys ,
              t.ItemType ,
              t.Sale ,
              t.SaleF ,
              t.SaleD ,
              t.SaleLL ,
              t.SaleEuro ,
              t.DiscountIs ,
              t.DiscountIsF ,
              t.DiscountIsValue ,
              t.DiscountIsValueF ,
              t.DiscountIsValueD ,
              t.DiscountIsValueLL ,
              t.DiscountIsValueEuro ,
              t.SubTotal ,
              t.SubTotalF ,
              t.SubTotalD ,
              t.SubTotalLL ,
              t.SubTotalEuro ,
              t.DiscountOrder ,
              t.DiscountOrderF ,
              t.DiscountOrderD ,
              t.DiscountOrderLL ,
              t.DiscountOrderEuro ,
              t.TaxRate ,
              t.TaxRateF ,
              t.TaxValue ,
              t.TaxValueF ,
              t.TaxValueD ,
              t.TaxValueLL ,
              t.TaxValueEuro ,
              t.Total ,
              t.TotalF ,
              t.TotalD ,
              t.TotalLL ,
              t.TotalEuro ,
              t.Cost ,
              t.CostF ,
              t.CostD ,
              t.CostLL ,
              t.CostEuro ,
              t.TotalCost ,
              t.TotalCostF ,
              t.TotalCostD ,
              t.TotalCostLL ,
              t.TotalCostEuro ,
              t.Profit ,
              t.ProfitF ,
              t.ProfitD ,
              t.ProfitLL ,
              t.ProfitEuro ,
              t.ProfitTotal ,
              t.ProfitTotalF ,
              t.ProfitTotalD ,
              t.ProfitTotalLL ,
              t.ProfitTotalEuro ,
              t.DescriptionIs ,
              t.SortAt ,
              t.DateCreate ,
              0 ,
              t.WorkStationID
            FROM Customers.t_FrameJobOrderDetail AS t
            WHERE t.FrameJobOrderID = @ID;

    END;

    BEGIN --Delete

      DELETE FROM Customers.t_FrameJobOrderDetail
        WHERE FrameJobOrderID = @ID;

      DELETE FROM Customers.t_FrameJobOrder
        WHERE ID = @ID;

    END;

    IF @StatesIs = 4
    BEGIN --Delete t_Transaction

      DELETE FROM Transactions.t_Transaction
        WHERE LinkType = 169 AND LinkID = @ID;

      BEGIN --Fix t_Customer

        UPDATE Customers.t_Customer
          SET FrameJobOrderC = Customers.f_FrameJobOrderGetCountByCustomerID(ID) ,
              FrameJobOrderTotal = Customers.[f_FrameJobOrderGetTotalByCustomerID](ID) ,
              FrameJobOrderProfit = Customers.[f_FrameJobOrderGetProfitByCustomerID](ID) ,
              FrameJobOrderLast = Customers.f_FrameJobOrderGetLastDateByCustomerID(ID)
          WHERE ID = @CustomerID;

        WITH  o AS ( SELECT s1.CurrencyID ,
                        s.FrameJobOrderTotal ,
                        s.FrameJobOrderTotalF ,
                        s.FrameJobOrderProfit ,
                        s.FrameJobOrderProfitF
                      FROM Customers.t_Customer AS s
                        INNER JOIN Company.t_Account AS s1 ON s1.LinkWithID = s.ID AND s1.IsMasterLink = 1 AND s1.SectionID = 15
                      WHERE s.ID = @CustomerID
                   )
          UPDATE o
            SET o.FrameJobOrderTotalF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderTotal) ,
                o.FrameJobOrderProfitF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderProfit);

      END;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Customers.t_FrameJobOrderMoving
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
            @EventType ,
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
