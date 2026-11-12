SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_SocialMediaTypeNotSync]
AS
SELECT  t.ID ,
        t.Name ,
        t.DescriptionIs ,
        t.SocialMediaC ,
        t.SearchText ,
        t.DateCreate
FROM    Company.t_SocialMediaType AS t
WHERE   t.IsSync = 0;




GO
