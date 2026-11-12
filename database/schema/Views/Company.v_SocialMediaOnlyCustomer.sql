SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create VIEW [Company].[v_SocialMediaOnlyCustomer]
AS
SELECT t.ID,
       t.OwnerID,
       t.AccountIs,
       t.TypeIs,
       t.DescriptionIs,
       t.DateCreate
FROM Company.t_SocialMedia AS t
WHERE t.SectionID = 15;





GO
