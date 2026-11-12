SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarRentalHistoryDriverReport]
AS
SELECT  t.ID ,
        t.CarRentalHistoryID ,
        t.CarDriverID ,
        t.CarDriver ,
        t1.DrivingLicense ,
        t1.DrivingLicenseIssuanceDate ,
        t1.DrivingLicenseStates ,
        t1.DrivingLicenseRegion ,
        t1.BirthdayStates ,
        t1.BirthdayRegion
FROM    Cars.t_CarRentalHistoryDriver AS t
INNER JOIN Cars.t_CarDriver AS t1 ON t1.ID = t.CarDriverID;



GO
