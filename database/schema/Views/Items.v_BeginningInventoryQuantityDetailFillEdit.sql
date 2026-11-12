SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_BeginningInventoryQuantityDetailFillEdit]
AS
SELECT t.ID ,
    t.BeginningInventoryQuantityID ,
    t.ItemSharedID ,
    t.ItemID ,
    t1.Name ,
    t1.Barcode ,
    t1.ImageThumbnail ,
    t.ItemUnityID ,
    t4.Name AS Unity ,
    t3.Qty AS UnityQty ,
    t.Qty ,
    t2.WareHouseID ,
    t2.WareHouse ,
    t.Price ,
    t.DescriptionIs ,
    t1.IsSerial ,
    t1.QtyCurrent ,
    t.SortAt
  FROM Items.t_BeginningInventoryQuantityDetail AS t
  INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
  INNER JOIN Items.t_Item AS t2 ON t2.ID = t.ItemID
  INNER JOIN Items.t_UnityItem AS t3 ON t3.ID = t.ItemUnityID
  INNER JOIN Items.t_Unity AS t4 ON t4.ID = t3.UnityID;
  

GO
