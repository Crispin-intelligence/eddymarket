SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_StockTakeDetailList1]
AS
SELECT t.ID,
       t.StockTakeID,
       t1.Name,
       t1.Barcode,
       t.QtyWithUnity,
       t.Total,
       t.TotalF,
       t.SortAt
FROM Items.t_StockTakeDetail AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID;





GO
