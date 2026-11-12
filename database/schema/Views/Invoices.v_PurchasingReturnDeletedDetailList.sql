SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Invoices].[v_PurchasingReturnDeletedDetailList]
AS
SELECT t.ID ,
    t.PurchasingReturnDeletedID ,
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
    t.DiscountIs ,
    t.DiscountIsValueF ,
    t.DiscountIsValueD ,
    t.SubTotalF ,
    t.SubTotalD ,
    t.DiscountInvoiceF ,
    t.DiscountInvoiceD ,
    t.TaxRate ,
    t.TaxValueF ,
    t.TaxValueD ,
    t.TotalF ,
    t.TotalD ,
    t.SellF ,
    t.SellD ,
    t.ProfitF ,
    t.ProfitD ,
    t.DescriptionIs ,
    t.SortAt ,
    t.DateCreate
  FROM Invoices.t_PurchasingReturnDeletedDetail AS t
  INNER JOIN Invoices.t_PurchasingReturnDeleted AS t1 ON t1.ID = t.PurchasingReturnDeletedID
  INNER JOIN Items.t_ItemShared AS t2 ON t2.ID = t.ItemSharedID;











GO
