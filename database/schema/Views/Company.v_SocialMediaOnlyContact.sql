SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_SocialMediaOnlyContact]
AS
SELECT t.ID,
       t.OwnerID,
       t.AccountIs,
       t.TypeIs,
       t.DescriptionIs,
       t.DateCreate
FROM Company.t_SocialMedia AS t
WHERE t.SectionID = 153;






GO
