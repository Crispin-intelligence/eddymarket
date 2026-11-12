SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_SoldReturnDetailNotSync]
AS
SELECT t.ID ,
       t.SoldReturnID ,
       t.ItemSharedID ,
       t1.Name,
       t1.Barcode,
       t.ItemID,
       t2.WareHouse,
       t2.Place,
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
FROM Invoices.t_SoldReturnDetail AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t2
        ON t2.ID = t.ItemID
WHERE t.IsSync = 0;









GO
