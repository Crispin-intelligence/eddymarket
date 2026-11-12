SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_SoldReturnDeletedDetail]
AS
SELECT t.ID ,
    t.SoldReturnDeletedID ,
    t.ItemSharedID ,
	t1.BrandID,
	t1.MainCategoryID,
	t1.SubCategoryID,
    t.ItemID ,
    t.ItemUnityID ,
    t.Qty ,
    t.QtyWithUnity ,
    t.Qtys ,
    t.Price ,
    t.PriceF ,
    t.PriceD ,
    t.PriceLL ,
    t.PriceEuro ,
    t.DiscountIs ,
    t.DiscountIsF ,
    t.DiscountIsValue ,
    t.DiscountIsValueF ,
    t.DiscountIsValueD ,
    t.DiscountIsValueLL ,
    t.DiscountIsValueEuro ,
    t.SubTotal ,
    t.SubTotalF ,
    t.SubTotalD ,
    t.SubTotalLL ,
    t.SubTotalEuro ,
    t.DiscountInvoice ,
    t.DiscountInvoiceF ,
    t.DiscountInvoiceD ,
    t.DiscountInvoiceLL ,
    t.DiscountInvoiceEuro ,
    t.TaxRate ,
    t.TaxRateF ,
    t.TaxValue ,
    t.TaxValueF ,
    t.TaxValueD ,
    t.TaxValueLL ,
    t.TaxValueEuro ,
    t.Total ,
    t.TotalF ,
    t.TotalD ,
    t.TotalLL ,
    t.TotalEuro ,
    t.Cost ,
    t.CostF ,
    t.CostD ,
    t.CostLL ,
    t.CostEuro ,
    t.Profit ,
    t.ProfitF ,
    t.ProfitD ,
    t.ProfitLL ,
    t.ProfitEuro ,
    t.ProfitTotal ,
    t.ProfitTotalF ,
    t.ProfitTotalD ,
    t.ProfitTotalLL ,
    t.ProfitTotalEuro ,
    t.DescriptionIs ,
    t.SortAt ,
    t.DateCreate
  FROM Invoices.t_SoldReturnDeletedDetail AS t
  INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID;




GO
