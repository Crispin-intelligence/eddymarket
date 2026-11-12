SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_ContactWithoutImage]
AS
SELECT t.ID,
       t.Name,
       t.Phones,
       t.PhonesC,
       t.SocialMedia,
       t.SocialMediaC,
       t.Gender,
       t.NationalityID,
       t.Nationality,
       t.TitleID,
       t.Title,
       t.ClassificationID,
       t.Classification,
       t.Birthday,
       t.AgeIs,
       t.StatesID,
       t.StatesIs,
       t.RegionID,
       t.RegionIs,
       t.StreetID,
       t.Street,
       t.BuildingID,
       t.Building,
       t.FloorID,
       t.FloorIs,
       t.PostalCodeID,
       t.PostalCode,
       t.AddressNote,
       t.AddressIs,
       t.DescriptionIs,
       t.DateCreate
FROM Company.t_Contact AS t;














GO
