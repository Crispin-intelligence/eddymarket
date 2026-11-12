SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemProductionMaterialSerialNotSync]
AS
SELECT t.ID,
       t.ItemProductionID,
       t.ItemProductionMaterialID,
       t.SerialID,
       t.DateCreate,
       t.IsSync
FROM Items.t_ItemProductionMaterialSerial AS t
WHERE t.IsSync = 0;


GO
