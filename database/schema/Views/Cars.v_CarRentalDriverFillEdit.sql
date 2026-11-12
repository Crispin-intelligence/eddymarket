SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Cars].[v_CarRentalDriverFillEdit]
AS
SELECT  t.ID ,
        t.CarRentalID ,
        t.CarDriverID ,
        t1.Name AS CarDriver ,
        t1.DrivingLicense ,
        t1.LicenseExpirationDate ,
        t1.ValidDriverLicense ,
        t1.BloodType ,
        t1.Phones ,
        t1.Gender ,
        t1.Nationality
FROM    Cars.t_CarRentalDriver AS t
INNER JOIN Cars.t_CarDriver AS t1 ON t1.ID = t.CarDriverID;




GO
