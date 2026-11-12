SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountChoosePerson]
AS
SELECT t.ID ,
    t.Name ,
    t.NumberF ,
    t.ShowInGymClass ,
    t.ShowInPersonalTrainer ,
    ISNULL(t1.Phones, '') AS Phones ,
    ISNULL(t1.AddressIs, '') AS AddressIs
  FROM Company.t_Account AS t
  LEFT JOIN Alls.v_Person AS t1 ON t1.ID = t.LinkWithID AND t1.SectionID = t.SectionID
  WHERE t.NumberIs BETWEEN 4010100000 AND 4019999999 OR t.NumberIs BETWEEN 4110100000 AND 4119999999 OR t.NumberIs BETWEEN 4210100000 AND 4219999999 OR t.NumberIs BETWEEN 4610100000 AND 4619999999 OR t.NumberIs BETWEEN 1090100000 AND 1099999999;







GO
