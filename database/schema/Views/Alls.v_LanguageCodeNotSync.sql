SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Alls].[v_LanguageCodeNotSync]
AS
SELECT  t.ID ,
        t.Name ,
        t.ShortCode ,
        t.FullCode ,
        t.ImagePath ,
        t.InternationalDialingPrefix ,
        t.CountryCallingCode ,
        t.DescriptionIs ,
        t.PhoneC ,
        t.SearchText ,
        t.DateCreate
FROM    Alls.t_LanguageCode AS t
WHERE   t.IsSync = 0;






GO
