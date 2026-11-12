SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Cars].[v_CarRentalHistoryDriverList]
AS
SELECT  t.ID ,
        t.CarRentalHistoryID ,
        t.CarDriverID ,
        t1.Name AS CarDriver ,
        t1.DrivingLicense ,
        t1.LicenseExpirationDate ,
        t1.BloodType ,
        t1.Phones ,
        t1.Gender ,
        t1.Nationality ,
        t.DateCreate ,
        t.IsSync
FROM    Cars.t_CarRentalHistoryDriver AS t
INNER JOIN Cars.t_CarDriver AS t1 ON t1.ID = t.CarDriverID;





GO
