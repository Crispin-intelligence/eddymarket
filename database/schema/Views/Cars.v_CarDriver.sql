SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Cars].[v_CarDriver]
AS
SELECT  t.ID ,
        t.Name ,
        t.DrivingLicense ,
        t.DrivingLicenseIssuanceDate ,
        t.LicenseExpirationDate ,
        t.ValidDriverLicense ,
        t.DrivingLicenseStatesID ,
        t.DrivingLicenseStates ,
        t.DrivingLicenseRegionID ,
        t.DrivingLicenseRegion ,
        t.BloodType ,
        t.Phones ,
        t.PhonesC ,
        t.SocialMedia ,
        t.SocialMediaC ,
        t.Gender ,
        t.NationalityID ,
        t.Nationality ,
        t.TitleID ,
        t.Title ,
        t.ClassificationID ,
        t.Classification ,
        t.Birthday ,
        t.BirthdayStatesID ,
        t.BirthdayStates ,
        t.BirthdayRegionID ,
        t.BirthdayRegion ,
        t.AgeIs ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        t.BuildingID ,
        t.Building ,
        t.FloorID ,
        t.FloorIs ,
        t.PostalCodeID ,
        t.PostalCode ,
        t.AddressNote ,
        t.AddressIs ,
        t.DescriptionIs ,
        t.ImageIs ,
        t.ImageThumbnail ,
        t.ImagePath ,
        t.CarRentalCount ,
        t.SearchText ,
        t.DateCreate ,
        t.IsSync ,
        t.IsSyncImage
FROM    Cars.t_CarDriver AS t;











GO
