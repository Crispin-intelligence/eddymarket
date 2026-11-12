SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_SoldReturnDeletedDetailList1]
AS
SELECT t.ID,
       t.SoldReturnDeletedID,
       t1.Name,
       t1.Barcode,
       t.QtyWithUnity,
       t.Total,
       t.TotalF,
       t.SortAt
FROM Invoices.t_SoldReturnDeletedDetail AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID;





GO
