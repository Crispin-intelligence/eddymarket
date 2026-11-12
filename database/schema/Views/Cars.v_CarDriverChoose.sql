SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarDriverChoose]
AS
SELECT  t.ID ,
        t.Name ,
        t.DrivingLicense ,
        t.LicenseExpirationDate ,
        t.BloodType ,
        t.Phones ,
        t.Gender ,
        t.Nationality ,
        t.DateCreate
FROM    Cars.t_CarDriver AS t;




GO
