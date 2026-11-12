SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ItemExpirationDateNotSync]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t.ItemSharedID ,
        t.ItemID ,
        t1.Name ,
        t1.Barcodes ,
        t.WareHouseID ,
        t.WareHouse ,
        t.PlaceID ,
        t.Place ,
        t.SectionIs ,
        t.SectionID ,
        t.Barcode ,
        t.Qtys ,
        t.ProductionDate ,
        t.ExpirationDate ,
        t.NotifyMeDaysBefore ,
        t.NotificationDate ,
        t.CurrencyID ,
        t.Currency ,
        t.Price ,
        t.PriceF ,
        t.PriceD ,
        t.PriceLL ,
        t.PriceEuro ,
        t.DescriptionIs ,
        t.SearchText ,
        t.DateCreate
FROM    Items.t_ItemExpirationDate AS t
INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
WHERE   t.IsSync = 0;






GO
