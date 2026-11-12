SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemProductionMaterialList1]
AS
SELECT t.ID,
       t.ItemProductionID,
       t1.Name,
       t1.Barcode,
       t.QtyWithUnity,
       t.Warehouse,
       t.TotalCost,
       t.TotalCostF,
       t.SortAt
FROM Items.t_ItemProductionMaterial AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID;



GO
