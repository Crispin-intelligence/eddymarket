SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ItemSharedBarCodeNotBlocked]
AS
SELECT t.ID ,
    t.SharedID ,
    t.BarCode ,
    t.BarcodeNumber ,
    t.TypeIs ,
    t.DateCreate
  FROM Items.t_ItemSharedBarCode AS t
  INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.SharedID
  WHERE t1.StatusIs <> 2;




GO
