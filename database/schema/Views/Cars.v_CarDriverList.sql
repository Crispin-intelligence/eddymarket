SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Cars].[v_CarDriverList]
AS
SELECT  t.ID ,
        t.Name ,
        t.DrivingLicense ,
        t.DrivingLicenseIssuanceDate ,
        t.LicenseExpirationDate ,
        t.ValidDriverLicense ,
        t.DrivingLicenseStates ,
        t.DrivingLicenseRegion ,
        t.BloodType ,
        t.Phones ,
        t.PhonesC ,
        t.SocialMedia ,
        t.SocialMediaC ,
        t.Gender ,
        t.Nationality ,
        t.TitleID ,
        t.Title ,
        t.Classification ,
        t.Birthday ,
        t.BirthdayStates ,
        t.BirthdayRegion ,
        t.AgeIs ,
        t.StatesIs ,
        t.RegionIs ,
        t.Street ,
        t.Building ,
        t.FloorIs ,
        t.PostalCode ,
        t.AddressNote ,
        t.AddressIs ,
        t.DescriptionIs ,
        t.ImageIs ,
        t.CarRentalCount ,
        t.DateCreate ,
        t.IsSync ,
        t.IsSyncImage
FROM    Cars.t_CarDriver AS t;








GO
