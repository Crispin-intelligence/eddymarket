SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_Doctor]
AS
SELECT  t.ID ,
        t.Name ,
        t.NameAR ,
        t.Phones ,
        t.PhonesC ,
        t.SocialMedia ,
        t.SocialMediaC ,
        t.Gender ,
        t.Birthday ,
        t.AgeIs ,
        t.ImageIs ,
        t.ImagePath ,
        t.Hospitals ,
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
        t.DateCreate ,
        t.IsSync ,
        t.IsSyncImage
FROM    Company.t_Doctor AS t;



GO
