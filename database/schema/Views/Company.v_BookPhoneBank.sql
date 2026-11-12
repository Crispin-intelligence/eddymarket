SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_BookPhoneBank]
AS
SELECT  t.ID ,
        t.OwnerID ,
        t2.Name ,
        t2.AddressIs ,
        t2.Phones ,
        t2.IDDoor ,
        t2.Birthday ,
        t.NumberIs ,
        t.SectionID ,
        t.NumberNet ,
        t.NumberNetPlus ,
        t.NumberWithExtension ,
        t.NumberType ,
        t.LanguageCodeID ,
        t.LanguageCode ,
        t.ExtensionIs ,
        t.DateCreate ,
        t.IsSync
FROM    Company.t_BookPhone AS t
INNER JOIN Alls.v_Person AS t2 ON t2.SectionID = t.SectionID
                                  AND t2.ID = t.OwnerID
WHERE   t.SectionID = 38;





GO
