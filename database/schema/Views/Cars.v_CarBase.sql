SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarBase]
AS
SELECT  t.ID ,
        t.FullName ,
        t.VehicleIdentificationNumber
FROM    Cars.t_Car AS t;





GO
