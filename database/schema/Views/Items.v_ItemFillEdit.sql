SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemFillEdit]
AS
SELECT t.ID ,
    t.SharedID ,
    t1.Name ,
    t1.Barcode ,
    t1.ImageThumbnail ,
    t1.CurrencyID ,
    t1.Purchase ,
    t1.IsSerial ,
    t.WareHouseID ,
    t.WareHouse ,
    t.QtyCurrent ,
    t.DateCreate
  FROM Items.t_Item AS t
  LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.SharedID;





GO
