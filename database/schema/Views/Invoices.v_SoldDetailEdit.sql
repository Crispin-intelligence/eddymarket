SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Invoices].[v_SoldDetailEdit]
AS
SELECT t.ID ,
    t.SoldID ,
    t1.Name ,
    t1.Barcode ,
    t2.WareHouse ,
    t.Qty ,
    t4.Name AS Unity ,
    t.Price ,
    t.PriceF ,
    t.Cost ,
    t.CostF ,
    t.TaxRate ,
    t.TaxRateF ,
    t.DiscountIs ,
    t.DiscountIsF ,
    t.RefPurchaseOrder ,
    t.DescriptionIs ,
    t.SortAt
  FROM Invoices.t_SoldDetail AS t
  LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
  LEFT JOIN Items.t_Item AS t2 ON t2.ID = t.ItemID
  LEFT JOIN Items.t_UnityItem AS t3 ON t3.ID = t.ItemUnityID
  LEFT JOIN Items.t_Unity AS t4 ON t4.ID = t3.UnityID;





GO
