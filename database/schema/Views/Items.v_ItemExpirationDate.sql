SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemExpirationDate]
AS
SELECT t.ID ,
       t.Ref ,
       t.RefF ,
       t.ItemSharedID ,
       t.ItemID ,
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
       t.DateCreate ,
       t.IsSync
FROM Items.t_ItemExpirationDate AS t;





GO
