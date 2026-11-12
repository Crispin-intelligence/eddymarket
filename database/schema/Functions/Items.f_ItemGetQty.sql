SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Items].[f_ItemGetQty]
(
    @ItemsID UNIQUEIDENTIFIER
)
RETURNS DECIMAL(18, 4)
AS
BEGIN

    DECLARE @QtyCurrent DECIMAL(18, 4) = 0.0;

    SET @QtyCurrent +=
    (
        SELECT COALESCE(SUM(Qtys), 0)
        FROM Invoices.t_PurchasingDetail
        WHERE ItemID = @ItemsID
    );

    SET @QtyCurrent -=
    (
        SELECT COALESCE(SUM(Qtys), 0)
        FROM Invoices.t_SoldDetail
        WHERE ItemID = @ItemsID
    );

    SET @QtyCurrent -=
    (
        SELECT COALESCE(SUM(Qtys), 0)
        FROM Invoices.t_PurchasingReturnDetail
        WHERE ItemID = @ItemsID
    );

    SET @QtyCurrent +=
    (
        SELECT COALESCE(SUM(Qtys), 0)
        FROM Invoices.t_SoldReturnDetail
        WHERE ItemID = @ItemsID
    );

    SET @QtyCurrent +=
    (
        SELECT COALESCE(SUM(Qtys), 0)
        FROM Items.t_BeginningInventoryQuantityDetail
        WHERE ItemID = @ItemsID
    );

    SET @QtyCurrent -=
    (
        SELECT COALESCE(SUM(s.Qtys), 0)
        FROM Invoices.t_TransferAwaitedDetail AS s
            LEFT JOIN Invoices.t_TransferAwaited AS s1
                ON s1.ID = s.TransferAwaitedID
            LEFT JOIN Company.t_WareHouse AS s2
                ON s2.ID = s1.FromWarehouseID
            LEFT JOIN Items.t_Item AS s3
                ON s3.WareHouseID = s2.ID
                   AND s3.SharedID = s.ItemSharedID
        WHERE s3.ID = @ItemsID
    );

    SET @QtyCurrent -=
    (
        SELECT COALESCE(SUM(s.Qtys), 0)
        FROM Invoices.t_TransferDetail AS s
            LEFT JOIN Invoices.t_Transfer AS s1
                ON s1.ID = s.TransferID
            LEFT JOIN Company.t_WareHouse AS s2
                ON s2.ID = s1.FromWarehouseID
            LEFT JOIN Items.t_Item AS s3
                ON s3.WareHouseID = s2.ID
                   AND s3.SharedID = s.ItemSharedID
        WHERE s3.ID = @ItemsID
    );

    SET @QtyCurrent +=
    (
        SELECT COALESCE(SUM(s.Qtys), 0)
        FROM Invoices.t_TransferDetail AS s
            LEFT JOIN Invoices.t_Transfer AS s1
                ON s1.ID = s.TransferID
            LEFT JOIN Company.t_WareHouse AS s2
                ON s2.ID = s1.ToWarehouseID
            LEFT JOIN Items.t_Item AS s3
                ON s3.WareHouseID = s2.ID
                   AND s3.SharedID = s.ItemSharedID
        WHERE s3.ID = @ItemsID
    );

    SET @QtyCurrent +=
    (
        SELECT COALESCE(SUM(Qtys), 0)
        FROM Items.t_StockAdjustmentDetail
        WHERE ItemID = @ItemsID
    );

    SET @QtyCurrent +=
    (
        SELECT COALESCE(SUM(Qtys), 0)
        FROM Items.t_StockTakeDetail
        WHERE ItemID = @ItemsID
    );
	
    SET @QtyCurrent +=
    (
        SELECT COALESCE(SUM(Qtys), 0)
        FROM Items.t_ItemProduction
        WHERE ItemID = @ItemsID
    );

    SET @QtyCurrent -=
    (
        SELECT COALESCE(SUM(s.Qtys), 0)
        FROM Items.t_ItemProductionMaterial AS s
        WHERE s.ItemID = @ItemsID
    );

    RETURN COALESCE(@QtyCurrent, 0);

END;























GO
