SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Customers].[v_CustomerNotSyncImageID]
AS
SELECT  t.ID ,
        t.Name ,
        t.ImageID ,
        t.ImageIDPath
FROM    Customers.t_Customer AS t
WHERE   t.IsSyncImageID = 0;





GO
