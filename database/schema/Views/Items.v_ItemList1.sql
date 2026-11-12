SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemList]
AS
SELECT  t.ID ,
        t.SharedID ,
        t1.Name ,
        t1.Barcodes ,
        t1.Brand ,
        t1.MainCategory ,
        t1.SubCategory ,
        t1.PurchaseWithTaxF ,
        t1.PurchaseWithTaxD ,
        t1.PurchaseWithTaxLL ,
        t1.PurchaseWithTaxEuro ,
        t1.PurchaseTotalWithTaxF ,
        t1.PurchaseTotalWithTaxD ,
        t1.PurchaseTotalWithTaxLL ,
        t1.PurchaseTotalWithTaxEuro ,
        t1.SellWithTaxF ,
        t1.SellWithTaxD ,
        t1.SellWithTaxLL ,
        t1.SellWithTaxEuro ,
        t1.SellTotalWithTaxF ,
        t1.SellTotalWithTaxD ,
        t1.SellTotalWithTaxLL ,
        t1.SellTotalWithTaxEuro ,
        t.WareHouseID ,
        t.WareHouse ,
        t.PlaceID ,
        t.Place ,
        t.QtyCurrent ,
        t.QtyCurrentByUnit ,
        t.QtyToReorder ,
        t.LastStockTakeDate ,
        t.StockTakeEvery ,
        t.StockTakeEveryType ,
        t.StockTakeEveryARF ,
        t.StockTakeEveryENF ,
        t.StockTakeEveryNotificationDate ,
        t.DescriptionIs ,
        t.DateCreate
FROM    Items.t_Item AS t
INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.SharedID;
		

GO
