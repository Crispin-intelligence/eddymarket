SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_BookPhoneOnlyCarDriver]
AS
SELECT  t.ID ,
        t.OwnerID ,
        t.NumberWithExtension ,
        t.NumberType ,
        t.LanguageCode ,
        t.ExtensionIs ,
        t.DateCreate
FROM    Company.t_BookPhone AS t
WHERE   ( t.SectionID = 184 );



GO
