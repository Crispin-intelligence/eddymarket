SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Invoices].[v_SoldDeletedDetailList]
AS
SELECT t.ID ,
    t.SoldDeletedID ,
    t1.Ref ,
    t1.RefF ,
    t1.DateIs ,
    t.ItemSharedID ,
    t2.Name ,
    t2.Barcodes ,
    t2.Brand ,
    t2.MainCategory ,
    t2.SubCategory ,
    t.Qty ,
    t.QtyWithUnity ,
    t.PriceF ,
    t.PriceD ,
    t.TaxRate ,
    t.TaxValueF ,
    t.TaxValueD ,
    t.DiscountIs ,
    t.DiscountIsValueF ,
    t.DiscountIsValueD ,
    t.TotalF ,
    t.TotalD ,
    t.CostF ,
    t.CostD ,
    t.ProfitF ,
    t.ProfitD ,
    t.RefPurchaseOrder ,
    t.DescriptionIs ,
    t.SortAt ,
    t.DateCreate ,
    t.IsSync
  FROM Invoices.t_SoldDeletedDetail AS t
  INNER JOIN Invoices.t_SoldDeleted AS t1 ON t1.ID = t.SoldDeletedID
  INNER JOIN Items.t_ItemShared AS t2 ON t2.ID = t.ItemSharedID;










GO
