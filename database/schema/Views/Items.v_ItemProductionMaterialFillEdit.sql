SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ItemProductionMaterialFillEdit]
AS
SELECT t.ID ,
    t.ItemProductionID ,
    t.ItemSharedID ,
    t1.Name ,
    t1.Barcode ,
    t1.IsSerial ,
    t1.ImageThumbnail ,
    t2.QtyCurrent ,
    t.ItemID ,
    t.ItemUnityID ,
    t3.Unity ,
    t3.Qty AS UnityQty ,
    t.Qty ,
    t.Qtys ,
    t.WarehouseID ,
    t.Warehouse ,
    t.Cost ,
    t.TotalCost ,
    t.DescriptionIs ,
    t.SortAt
  FROM Items.t_ItemProductionMaterial AS t
  LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
  LEFT JOIN Items.t_Item AS t2 ON t2.ID = t.ItemID
  LEFT JOIN Items.t_UnityItem AS t3 ON t3.ID = t.ItemUnityID;








GO
