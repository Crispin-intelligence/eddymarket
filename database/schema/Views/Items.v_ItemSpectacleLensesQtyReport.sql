SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ItemSpectacleLensesQtyReport]
AS
SELECT t.ID ,
    t.WareHouseID ,
    t.QtyCurrent ,
    t.QtyToReorder ,
    t1.SpectacleLensesFocal ,
    t1.SpectacleLensesCylinder ,
    t1.SpectacleLensesSphere
  FROM Items.t_Item AS t
  LEFT OUTER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.SharedID
  WHERE t1.OpticType = 1;
  


GO
