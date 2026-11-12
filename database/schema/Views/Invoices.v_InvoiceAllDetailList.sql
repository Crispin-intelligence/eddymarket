SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_InvoiceAllDetailList]
AS
SELECT t.ID,
       0 AS SectionID,
       t.PurchasingID AS InvoiceID,
       t1.Ref,
       t1.RefF,
       t1.DateIs,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t.Qty,
       t.QtyWithUnity,
       t.PriceF,
       t.PriceD,
       t.TaxRate,
       t.TaxValueF,
       t.TaxValueD,
       t.DiscountIs,
       t.DiscountIsValueF,
       t.DiscountIsValueD,
       t.TotalF,
       t.TotalD,
       t.ProfitF,
       t.ProfitD,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate
FROM Invoices.t_PurchasingDetail AS t
    LEFT JOIN Invoices.t_Purchasing AS t1
        ON t1.ID = t.PurchasingID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
UNION ALL
SELECT t.ID,
       1 AS SectionID,
       t.PurchasingReturnID,
       t1.Ref,
       t1.RefF,
       t1.DateIs,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t.Qty,
       t.QtyWithUnity,
       t.PriceF,
       t.PriceD,
       t.TaxRate,
       t.TaxValueF,
       t.TaxValueD,
       t.DiscountIs,
       t.DiscountIsValueF,
       t.DiscountIsValueD,
       t.TotalF,
       t.TotalD,
       t.ProfitF,
       t.ProfitD,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate
FROM Invoices.t_PurchasingReturnDetail AS t
    LEFT JOIN Invoices.t_PurchasingReturn AS t1
        ON t1.ID = t.PurchasingReturnID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
UNION ALL
SELECT t.ID,
       2 AS SectionID,
       t.SoldID AS InvoiceID,
       t1.Ref,
       t1.RefF,
       t1.DateIs,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t.Qty,
       t.QtyWithUnity,
       t.PriceF,
       t.PriceD,
       t.TaxRate,
       t.TaxValueF,
       t.TaxValueD,
       t.DiscountIs,
       t.DiscountIsValueF,
       t.DiscountIsValueD,
       t.TotalF,
       t.TotalD,
       t.ProfitF,
       t.ProfitD,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate
FROM Invoices.t_SoldDetail AS t
    LEFT JOIN Invoices.t_Sold AS t1
        ON t1.ID = t.SoldID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
UNION ALL
SELECT t.ID,
       3 AS SectionID,
       t.SoldReturnID,
       t1.Ref,
       t1.RefF,
       t1.DateIs,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t.Qty,
       t.QtyWithUnity,
       t.PriceF,
       t.PriceD,
       t.TaxRate,
       t.TaxValueF,
       t.TaxValueD,
       t.DiscountIs,
       t.DiscountIsValueF,
       t.DiscountIsValueD,
       t.TotalF,
       t.TotalD,
       t.ProfitF,
       t.ProfitD,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate
FROM Invoices.t_SoldReturnDetail AS t
    LEFT JOIN Invoices.t_SoldReturn AS t1
        ON t1.ID = t.SoldReturnID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
UNION ALL
SELECT t.ID,
       4 AS SectionID,
       t.QuotationID,
       t1.Ref,
       t1.RefF,
       t1.DateIs,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t.Qty,
       t.QtyWithUnity,
       t.PriceF,
       t.PriceD,
       t.TaxRate,
       t.TaxValueF,
       t.TaxValueD,
       t.DiscountIs,
       t.DiscountIsValueF,
       t.DiscountIsValueD,
       t.TotalF,
       t.TotalD,
       t.ProfitF,
       t.ProfitD,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate
FROM Quotations.t_QuotationDetail AS t
    LEFT JOIN Quotations.t_Quotation AS t1
        ON t1.ID = t.QuotationID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
UNION ALL
SELECT t.ID,
       4 AS SectionID,
       t.QuotationHistoryID,
       t1.Ref,
       t1.RefF,
       t1.DateIs,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t.Qty,
       t.QtyWithUnity,
       t.PriceF,
       t.PriceD,
       t.TaxRate,
       t.TaxValueF,
       t.TaxValueD,
       t.DiscountIs,
       t.DiscountIsValueF,
       t.DiscountIsValueD,
       t.TotalF,
       t.TotalD,
       t.ProfitF,
       t.ProfitD,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate
FROM Quotations.t_QuotationHistoryDetail AS t
    LEFT JOIN Quotations.t_QuotationHistory AS t1
        ON t1.ID = t.QuotationHistoryID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID;






GO
