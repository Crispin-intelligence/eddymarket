SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Items].[v_StockTakeDetailList]
AS
SELECT t.ID,
       t.StockTakeID,
       t1.Ref,
       t1.RefF,
       t1.DateIs,
	   t1.Warehouse,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
	   t.QtyCurrent,
	   t.QtyOnHand,
       t.Qty,
       t.QtyWithUnity,
       t.PriceF,
       t.PriceD,
       t.TotalF,
       t.TotalD,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate
FROM Items.t_StockTakeDetail AS t
    LEFT JOIN Items.t_StockTake AS t1
        ON t1.ID = t.StockTakeID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID;




GO
