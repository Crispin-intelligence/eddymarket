SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Invoices].[v_PurchasingReturnDeletedDetailList1]
AS
SELECT t.ID,
       t.PurchasingReturnDeletedID,
       t1.Name,
       t1.Barcode,
       t.QtyWithUnity,
       t.Total,
       t.TotalF,
       t.SortAt,
       t.IsSync
FROM Invoices.t_PurchasingReturnDeletedDetail AS t
    LEFT OUTER JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID;

GO
