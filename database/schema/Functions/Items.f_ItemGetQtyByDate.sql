SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Items].[f_ItemGetQtyByDate]
    (
      @ItemsID UNIQUEIDENTIFIER ,
      @DateIs DATETIME
    )
RETURNS DECIMAL(18, 4)
AS
BEGIN

    DECLARE @QtyCurrent DECIMAL(18, 4) = 0.0;

    SET @QtyCurrent += ( SELECT COALESCE(SUM(t.Qtys), 0)
                         FROM   Invoices.t_PurchasingDetail AS t
                                LEFT JOIN Invoices.t_Purchasing AS t1 ON t1.ID = t.PurchasingID
                         WHERE  t.ItemID = @ItemsID
                                AND t1.DateIs <= @DateIs
                       );

    SET @QtyCurrent -= ( SELECT COALESCE(SUM(t.Qtys), 0)
                         FROM   Invoices.t_SoldDetail AS t
                                LEFT JOIN Invoices.t_Sold AS t1 ON t1.ID = t.SoldID
                         WHERE  t.ItemID = @ItemsID
                                AND t1.DateIs <= @DateIs
                       );

    SET @QtyCurrent -= ( SELECT COALESCE(SUM(t.Qtys), 0)
                         FROM   Invoices.t_PurchasingReturnDetail AS t
                                LEFT JOIN Invoices.t_PurchasingReturn AS t1 ON t1.ID = t.PurchasingReturnID
                         WHERE  t.ItemID = @ItemsID
                                AND t1.DateIs <= @DateIs
                       );

    SET @QtyCurrent += ( SELECT COALESCE(SUM(t.Qtys), 0)
                         FROM   Invoices.t_SoldReturnDetail AS t
                                LEFT JOIN Invoices.t_SoldReturn AS t1 ON t1.ID = t.SoldReturnID
                         WHERE  t.ItemID = @ItemsID
                                AND t1.DateIs <= @DateIs
                       );

    SET @QtyCurrent += ( SELECT COALESCE(SUM(t.Qtys), 0)
                         FROM   Items.t_BeginningInventoryQuantityDetail AS t
                                LEFT JOIN Items.t_BeginningInventoryQuantity AS t1 ON t1.ID = t.BeginningInventoryQuantityID
                         WHERE  t.ItemID = @ItemsID
                                AND t1.DateIs <= @DateIs
                       );

    SET @QtyCurrent -= ( SELECT COALESCE(SUM(s.Qtys), 0)
                         FROM   Invoices.t_TransferAwaitedDetail AS s
                                LEFT JOIN Invoices.t_TransferAwaited AS s1 ON s1.ID = s.TransferAwaitedID
                                LEFT JOIN Company.t_WareHouse AS s2 ON s2.ID = s1.FromWarehouseID
                                LEFT JOIN Items.t_Item AS s3 ON s3.WareHouseID = s2.ID
                                                                AND s3.SharedID = s.ItemSharedID
                         WHERE  s3.ID = @ItemsID
                                AND s1.DateIs <= @DateIs
                       );

    SET @QtyCurrent -= ( SELECT COALESCE(SUM(s.Qtys), 0)
                         FROM   Invoices.t_TransferDetail AS s
                                LEFT JOIN Invoices.t_Transfer AS s1 ON s1.ID = s.TransferID
                                LEFT JOIN Company.t_WareHouse AS s2 ON s2.ID = s1.FromWarehouseID
                                LEFT JOIN Items.t_Item AS s3 ON s3.WareHouseID = s2.ID
                                                                AND s3.SharedID = s.ItemSharedID
                         WHERE  s3.ID = @ItemsID
                                AND s1.DateIs <= @DateIs
                       );

    SET @QtyCurrent += ( SELECT COALESCE(SUM(s.Qtys), 0)
                         FROM   Invoices.t_TransferDetail AS s
                                LEFT JOIN Invoices.t_Transfer AS s1 ON s1.ID = s.TransferID
                                LEFT JOIN Company.t_WareHouse AS s2 ON s2.ID = s1.ToWarehouseID
                                LEFT JOIN Items.t_Item AS s3 ON s3.WareHouseID = s2.ID
                                                                AND s3.SharedID = s.ItemSharedID
                         WHERE  s3.ID = @ItemsID
                                AND s1.DateIs <= @DateIs
                       );

    SET @QtyCurrent += ( SELECT COALESCE(SUM(t.Qtys), 0)
                         FROM   Items.t_StockAdjustmentDetail AS t
                                LEFT JOIN Items.t_StockAdjustment AS t1 ON t1.ID = t.StockAdjustmentID
                         WHERE  t.ItemID = @ItemsID
                                AND t1.DateIs <= @DateIs
                       );

    SET @QtyCurrent += ( SELECT COALESCE(SUM(t.Qtys), 0)
                         FROM   Items.t_StockTakeDetail AS t
                                LEFT JOIN Items.t_StockTake AS t1 ON t1.ID = t.StockTakeID
                         WHERE  t.ItemID = @ItemsID
                                AND t1.DateIs <= @DateIs
                       );
	
    SET @QtyCurrent += ( SELECT COALESCE(SUM(Qtys), 0)
                         FROM   Items.t_ItemProduction
                         WHERE  ItemID = @ItemsID
                                AND DateIs <= @DateIs
                       );

    SET @QtyCurrent -= ( SELECT COALESCE(SUM(t.Qtys), 0)
                         FROM   Items.t_ItemProductionMaterial AS t
                                LEFT JOIN Items.t_ItemProduction AS t1 ON t1.ID = t.ItemProductionID
                         WHERE  t.ItemID = @ItemsID
                                AND t1.DateIs <= @DateIs
                       );

    RETURN ISNULL(@QtyCurrent, 0);

END;



GO
