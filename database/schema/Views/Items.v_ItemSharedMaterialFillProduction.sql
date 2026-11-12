SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Items].[v_ItemSharedMaterialFillProduction]
AS
SELECT t.ID ,
    t.ItemSharedFatherID ,
    t.ItemSharedID ,
    t1.Name ,
    t1.Barcode ,
    t1.ImageThumbnail ,
    t1.CurrencyID ,
    t1.Purchase ,
    t1.PurchaseF ,
    t1.PurchaseD ,
    t1.PurchaseLL ,
    t1.PurchaseEuro ,
    t1.IsSerial ,
    t.ItemUnityID ,
    t3.Name AS Unity ,
    t2.Qty AS UnityQty ,
    t.Qty ,
    t.Qtys ,
    t.DescriptionIs
  FROM Items.t_ItemSharedMaterial AS t
  INNER JOIN Items.t_ItemShared AS t1 ON t.ItemSharedID = t1.ID
  LEFT JOIN Items.t_UnityItem AS t2 ON t2.ID = t.ItemUnityID
  LEFT JOIN Items.t_Unity AS t3 ON t3.ID = t2.UnityID;






GO
