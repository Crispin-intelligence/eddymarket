SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_StockAdjustmentDetailList1]
AS
SELECT t.ID,
       t.StockAdjustmentID,
       t1.Name,
       t1.Barcode,
       t.QtyWithUnity,
       t.Total,
       t.TotalF,
       t.SortAt
FROM Items.t_StockAdjustmentDetail AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID;




GO
