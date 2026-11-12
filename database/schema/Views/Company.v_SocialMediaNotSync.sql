SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_SocialMediaNotSync]
AS
SELECT  t.ID ,
        t.OwnerID ,
        t.AccountIs ,
        t.SectionID ,
        t.TypeID ,
        t.TypeIs ,
        t.DescriptionIs ,
        t.SearchText ,
        t.DateCreate
FROM    Company.t_SocialMedia AS t
WHERE   t.IsSync = 0;





GO
