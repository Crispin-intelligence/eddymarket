SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemSharedVendorNotSync]
AS
SELECT  t.ID ,
        t.SharedID ,
        t1.Name ,
        t1.Barcode ,
        t1.Barcodes ,
        t.VendorID ,
        t.Vendor ,
        t.ItemCode ,
        t.UnitIs ,
        t.CurrencyID ,
        t.Currency ,
        t.Price ,
        t.PriceF ,
        t.PriceD ,
        t.DescriptionIs ,
        t.SearchText ,
        t.DateCreate
FROM    Items.t_ItemSharedVendor AS t
INNER JOIN Items.t_ItemShared AS t1 ON t.SharedID = t1.ID
WHERE   t.IsSync = 0;





GO
