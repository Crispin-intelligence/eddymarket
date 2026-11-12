SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Invoices].[v_PurchasingReturnDetailReport]
AS
SELECT t.ID,
       t.PurchasingReturnID,
       t1.Name,
       t1.NameInvoice,
       t1.Barcode,
	   t1.Brand,
        t.DescriptionIs ,
       t1.IsSerial,
       t.Qty,
       t.QtyWithUnity,
       t2.PrimaryIs,
	   t2.Unity,
       t.Price,
       t.DiscountIs,
       t.DiscountIsF,
       t.SubTotal,
	   t.TaxRate,
       t.Total,
       t.SortAt
FROM Invoices.t_PurchasingReturnDetail AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID
		LEFT JOIN Items.t_UnityItem AS t2
		ON t2.ID = t.ItemUnityID;









GO
