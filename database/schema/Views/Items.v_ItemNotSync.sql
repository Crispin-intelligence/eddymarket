SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemNotSync]
AS
SELECT  t.ID ,
        t.ID1 ,
        t.SharedID ,
        t1.Name ,
        t1.Barcode ,
        t1.Barcodes ,
        t.WareHouseID ,
        t.WareHouse ,
        t.PlaceID ,
        t.Place ,
        t.QtyCurrent ,
        t.QtyCurrentByUnit ,
        t.QtyToReorder ,
        t.TypeIs ,
        t.DescriptionIs ,
        t.LastStockTakeDate ,
        t.StockTakeEvery ,
        t.StockTakeEveryType ,
        t.StockTakeEveryARF ,
        t.StockTakeEveryENF ,
        t.StockTakeEveryNotificationDate ,
        t.SearchText ,
        t.DateCreate
FROM    Items.t_Item AS t
INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.SharedID
WHERE   t.IsSync = 0;







GO
