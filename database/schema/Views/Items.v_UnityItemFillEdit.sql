SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Items].[v_UnityItemFillEdit]
AS
SELECT t.ID ,
    t.Unity ,
    t.SharedID ,
    t1.Name ,
    t1.Barcode ,
    t1.Barcodes ,
    t1.MainCategory ,
    t1.SubCategory ,
    t1.Brand ,
    t.QtyCurrent ,
    t.PrimaryIs ,
    t.CurrencyID ,
    t.Currency ,
    t.CostWithTaxD ,
    t.CostWithTaxF ,
    t.Price ,
    t.PriceWithTax ,
    t.LowestPrice
  FROM Items.t_UnityItem AS t
  INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.SharedID;

		




GO
