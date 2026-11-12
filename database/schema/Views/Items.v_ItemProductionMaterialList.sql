SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Items].[v_ItemProductionMaterialList]
AS
SELECT t.ID,
       t1.Ref,
       t1.RefF,
	   t1.DateIs,
       t.ItemProductionID,
       t.ItemSharedID,
       t2.Name,
       t2.Barcode,
       t2.Barcodes,
	   t.ItemUnityID,
       t3.Unity,
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
FROM Items.t_ItemProductionMaterial AS t
    LEFT JOIN Items.t_ItemProduction AS t1
        ON t1.ID = t.ItemProductionID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
    LEFT JOIN Items.t_UnityItem AS t3
        ON t3.ID = t.ItemUnityID;







GO
