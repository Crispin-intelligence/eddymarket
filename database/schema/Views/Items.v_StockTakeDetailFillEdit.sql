SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Items].[v_StockTakeDetailFillEdit]
AS
SELECT t.ID ,
    t.StockTakeID ,
    t.ItemSharedID ,
    t.ItemID ,
    t1.Name ,
    t1.Barcode ,
    t1.ImageThumbnail ,
    t.ItemUnityID ,
    t4.Name AS Unity ,
    t3.Qty AS UnityQty ,
    t.QtyCurrent ,
    t.QtyOnHand ,
    t.Qty ,
    t.Qtys ,
    t2.WareHouseID ,
    t2.WareHouse ,
    t.Price ,
    t.Total ,
    t.DescriptionIs ,
    t1.IsSerial ,
    t.SortAt
  FROM Items.t_StockTakeDetail AS t
  LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
  LEFT JOIN Items.t_Item AS t2 ON t2.ID = t.ItemID
  LEFT JOIN Items.t_UnityItem AS t3 ON t3.ID = t.ItemUnityID
  LEFT JOIN Items.t_Unity AS t4 ON t4.ID = t3.UnityID;









GO
