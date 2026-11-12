SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Company].[v_DoctorList]
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
        t.Hospitals ,
        t.StatesIs ,
        t.RegionIs ,
        t.Street ,
        t.Building ,
        t.FloorIs ,
        t.PostalCode ,
        t.AddressNote ,
        t.AddressIs ,
        t.DescriptionIs ,
        t.DateCreate ,
        t.IsSync ,
        t.IsSyncImage
FROM    Company.t_Doctor AS t;





GO
