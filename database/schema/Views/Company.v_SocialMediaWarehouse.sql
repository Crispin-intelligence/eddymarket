SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_SocialMediaWarehouse]
AS
SELECT  t.ID ,
        t.OwnerID ,
        t2.Name ,
        t2.AddressIs ,
        t2.Phones ,
        t.AccountIs ,
        t.SectionID ,
        t.TypeID ,
        t.TypeIs ,
        t.DescriptionIs ,
        t.DateCreate ,
        t.IsSync
FROM    Company.t_SocialMedia AS t
INNER JOIN Alls.v_Person AS t2 ON t2.SectionID = t.SectionID
                                  AND t2.ID = t.OwnerID
WHERE   t.SectionID = 42;



GO
