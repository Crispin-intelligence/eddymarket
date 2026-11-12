SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_DoctorChoose]
AS
SELECT  t.ID ,
        t.Name ,
        t.Phones ,
        t.SocialMedia ,
        t.AddressIs ,
        t.DescriptionIs
FROM    Company.t_Doctor AS t;




GO
