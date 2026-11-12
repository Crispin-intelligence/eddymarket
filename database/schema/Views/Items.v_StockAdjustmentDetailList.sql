SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_StockAdjustmentDetailList]
AS
SELECT t.ID,
       t.StockAdjustmentID,
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
       t.TotalF,
       t.TotalD,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate
FROM Items.t_StockAdjustmentDetail AS t
    LEFT JOIN Items.t_StockAdjustment AS t1
        ON t1.ID = t.StockAdjustmentID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID;


GO
