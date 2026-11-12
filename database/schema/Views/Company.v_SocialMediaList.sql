SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_SocialMediaList]
AS
SELECT  t.ID ,
        t.OwnerID ,
        t.AccountIs ,
        t.SectionID ,
        t.TypeIs ,
        t.DescriptionIs ,
        t.DateCreate ,
        t.IsSync
FROM    Company.t_SocialMedia AS t
INNER JOIN Alls.v_Person AS t2 ON t2.SectionID = t.SectionID
                                  AND t2.ID = t.OwnerID;





GO
