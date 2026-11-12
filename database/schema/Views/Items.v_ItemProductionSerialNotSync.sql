SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemProductionSerialNotSync]
AS
SELECT t.ID,
       t.ItemProductionID,
       t.SerialID,
       t.DateCreate,
       t.IsSync
FROM Items.t_ItemProductionSerial AS t
WHERE t.IsSync = 0;


GO
