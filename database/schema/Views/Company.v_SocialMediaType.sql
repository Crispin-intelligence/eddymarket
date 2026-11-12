SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_SocialMediaType]
AS
SELECT t.ID ,
       t.Name ,
       t.DescriptionIs ,
       t.SocialMediaC ,
       t.DateCreate ,
       t.IsSync 
FROM Company.t_SocialMediaType AS t;



GO
