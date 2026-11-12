SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Invoices].[v_SoldDetailNotSync]
AS
SELECT  t.ID ,
        t1.RefF ,
        t1.DateIs ,
        t1.AccountCustomer ,
        t2.Name ,
        t2.Barcode ,
        t3.WareHouse ,
        t3.Place ,
        t.SoldID ,
        t.ItemSharedID ,
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
        t.RefPurchaseOrder ,
        t.DescriptionIs ,
        t.SortAt ,
        t.SearchText ,
        t.DateCreate
FROM    Invoices.t_SoldDetail AS t
INNER JOIN Invoices.t_Sold AS t1 ON t1.ID = t.SoldID
INNER JOIN Items.t_ItemShared AS t2 ON t2.ID = t.ItemSharedID
INNER JOIN Items.t_Item AS t3 ON t3.ID = t.ItemID
WHERE   t.IsSync = 0;



GO
