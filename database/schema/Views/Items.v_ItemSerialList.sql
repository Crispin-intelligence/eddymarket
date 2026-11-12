SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemSerialList]
AS
SELECT t.ID,
       t.ItemSharedID,
       t1.Name,
       t1.Barcodes,
       t.ItemID,
       t2.WareHouse,
       t2.Place,
       t.SerialText,
       t.IsAvailable,
       t.SectionType,
       t.LinkID,
       t.LastSectionID,
       t.DateCreate
FROM Items.t_ItemSerial AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t2
        ON t2.ID = t.ItemID;




GO
