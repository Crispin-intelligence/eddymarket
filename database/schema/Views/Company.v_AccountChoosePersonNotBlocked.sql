SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_AccountChoosePersonNotBlocked]
AS
SELECT  t.ID ,
        t.Name ,
        t.NumberF ,
        t.ShowInGymClass ,
        t.ShowInPersonalTrainer ,
        FORMAT(ISNULL(t1.IDDoor, -1), N'0') AS IDDoor ,
        ISNULL(t1.Phones, '') AS Phones ,
        ISNULL(t1.AddressIs, '') AS AddressIs
FROM    ( SELECT  s.ID ,
                  s.Name ,
                  s.NumberIs ,
                  s.NumberF ,
                  s.ShowInGymClass ,
                  s.ShowInPersonalTrainer ,
                  s.LinkWithID ,
                  s.SectionID
          FROM    Company.t_Account AS s
          WHERE   s.StatusIs <> 2
        ) AS t
LEFT JOIN Alls.v_Person AS t1 ON t1.ID = t.LinkWithID
                                 AND t1.SectionID = t.SectionID
WHERE   t.NumberIs BETWEEN 4010100000 AND 4019999999
        OR t.NumberIs BETWEEN 4110100000 AND 4119999999
        OR t.NumberIs BETWEEN 4210100000 AND 4219999999
        OR t.NumberIs BETWEEN 4610100000 AND 4619999999
        OR t.NumberIs BETWEEN 1090100000 AND 1099999999;








GO
