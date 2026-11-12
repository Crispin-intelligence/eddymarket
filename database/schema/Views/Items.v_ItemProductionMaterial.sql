SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ItemProductionMaterial]
AS
SELECT t.ID,
       t.ItemProductionID,
       t.ItemSharedID,
       t.ItemID,
       t.ItemUnityID,
       t.Qty,
       t.QtyWithUnity,
       t.Qtys,
       t.WarehouseID,
       t.Warehouse,
       t.Cost,
       t.CostF,
       t.CostD,
       t.CostLL,
       t.CostEuro,
       t.TotalCost,
       t.TotalCostF,
       t.TotalCostD,
       t.TotalCostLL,
       t.TotalCostEuro,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate,
	   t.IsSync
FROM Items.t_ItemProductionMaterial AS t;






GO
