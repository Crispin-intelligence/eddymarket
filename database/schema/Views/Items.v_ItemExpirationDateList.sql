SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ItemExpirationDateList]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t1.Name ,
        t1.Barcodes ,
        t.WareHouse ,
        t.Place ,
        t.SectionIs ,
        t.Barcode ,
        t.Qtys ,
        t.ProductionDate ,
        t.ExpirationDate ,
        t.NotifyMeDaysBefore ,
        t.NotificationDate ,
        t.Currency ,
        t.Price ,
        t.PriceF ,
        t.PriceD ,
        t.PriceLL ,
        t.PriceEuro ,
        t.DescriptionIs ,
        t.SearchText ,
        t.DateCreate ,
        t.IsSync
FROM    Items.t_ItemExpirationDate AS t
INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID;
		



GO
