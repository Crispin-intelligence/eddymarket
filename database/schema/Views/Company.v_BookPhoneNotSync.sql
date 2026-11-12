SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_BookPhoneNotSync]
AS
SELECT  t.ID ,
        t.OwnerID ,
        t.SectionID ,
        t.NumberIs ,
        t.NumberNet ,
        t.NumberNetPlus ,
        t.NumberWithExtension ,
        t.NumberType ,
        t.LanguageCodeID ,
        t.LanguageCode ,
        t.ExtensionIs ,
        t.SearchText ,
        t.DateCreate
FROM    Company.t_BookPhone AS t
WHERE   t.IsSync = 0;


GO
