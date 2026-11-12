SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_StockTakeDetailReceipt]
AS
SELECT t.ID,
       t.StockTakeID,
       t1.Name,
       t.Qty,
	   t2.PrimaryIs,
	   t2.Unity,
       t.Total,
       t.SortAt
FROM Items.t_StockTakeDetail AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID
		LEFT JOIN Items.t_UnityItem AS t2
		ON t2.ID = t.ItemUnityID;


GO
