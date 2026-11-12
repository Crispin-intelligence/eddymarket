SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Items].[v_ItemPrintForInventory]
AS
SELECT t.ID,
       t.SharedID,
       t1.Name,
       t1.Barcode,
       t.WareHouse,
       t.Place,
       t.QtyCurrent,
	   t1.IsSerial
FROM Items.t_Item (NOLOCK) AS t
    LEFT JOIN Items.t_ItemShared (NOLOCK) AS t1
        ON t1.ID = t.SharedID;




GO
