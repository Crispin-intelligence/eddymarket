SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Cars].[v_CarNotSyncImage]
AS
SELECT  t.ID ,
        t.VehicleIdentificationNumber ,
        t.ImageIs ,
        t.ImagePath
FROM    Cars.t_Car AS t
WHERE   t.IsSyncImage = 0;




GO
