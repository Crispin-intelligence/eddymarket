SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_BookPhoneChoose]
AS
SELECT  t.ID ,
        t.OwnerID ,
        t1.Name ,
        t.SectionID ,
        t.NumberIs ,
        t.NumberNet ,
        t.NumberType ,
        t2.InternationalDialingPrefix
FROM    Company.t_BookPhone AS t
        LEFT JOIN Alls.v_Person AS t1 ON t1.SectionID = t.SectionID
                                         AND t1.ID = t.OwnerID
        LEFT JOIN Alls.t_LanguageCode AS t2 ON t2.ID = t.LanguageCodeID;


GO
