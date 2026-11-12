SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_TransferAwaitedDetailFillEdit]
AS
SELECT t.ID ,
    t.TransferAwaitedID ,
    t.ItemSharedID ,
    t3.ID AS ItemID ,
    t2.Name ,
    t2.Barcode ,
    t2.ImageThumbnail ,
    t.ItemUnityID ,
    t5.Name AS Unity ,
    t4.Qty AS UnityQty ,
    t.Qty ,
    t.Qtys ,
    t3.WareHouseID ,
    t3.WareHouse ,
    t.Price ,
    t.TaxRate ,
    t.TaxValue ,
    t.DiscountIs ,
    t.DiscountIsValue ,
    t.Total ,
    t.DescriptionIs ,
    t2.IsSerial ,
    t2.QtyCurrent ,
    t.SortAt
  FROM Invoices.t_TransferAwaitedDetail AS t
  INNER JOIN Invoices.t_TransferAwaited AS t1 ON t1.ID = t.TransferAwaitedID
  INNER JOIN Items.t_ItemShared AS t2 ON t2.ID = t.ItemSharedID
  INNER JOIN Items.t_Item AS t3 ON t3.SharedID = t.ItemSharedID AND t3.WareHouseID = t1.FromWarehouseID
  INNER JOIN Items.t_UnityItem AS t4 ON t4.ID = t.ItemUnityID
  INNER JOIN Items.t_Unity AS t5 ON t5.ID = t4.UnityID;




GO
