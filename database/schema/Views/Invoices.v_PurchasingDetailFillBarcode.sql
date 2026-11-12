SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_PurchasingDetailFillBarcode]
AS
SELECT t.ID,
       t.PurchasingID,
       t.ItemSharedID,
       t1.Name,
       t1.Barcode,
       t.Qty,
       t.Qtys,
       t1.SellWithTaxF,
       t1.QtyCurrent
FROM Invoices.t_PurchasingDetail AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID;



GO
