SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarNotSyncDamagesImage]
AS
SELECT  t.ID ,
        t.VehicleIdentificationNumber ,
        t.DamagesImage ,
        t.DamagesImagePath
FROM    Cars.t_Car AS t
WHERE   t.IsSyncDamagesImage = 0;



GO
