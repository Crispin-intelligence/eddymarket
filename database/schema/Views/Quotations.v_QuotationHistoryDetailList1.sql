SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Quotations].[v_QuotationHistoryDetailList1]
AS
SELECT t.ID,
       t.QuotationHistoryID,
       t1.Name,
       t1.Barcode,
       t.QtyWithUnity,
       t.Total,
       t.TotalF,
       t.SortAt
FROM Quotations.t_QuotationHistoryDetail AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID;




GO
