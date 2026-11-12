SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountChooseCustomerVendorNotBlocked]
AS
SELECT t.ID ,
    t.Name ,
    t.NumberF ,
    t.ShowInGymClass ,
    t.ShowInPersonalTrainer ,
    t1.Phones ,
    t1.AddressIs
  FROM Company.t_Account AS t
  INNER JOIN Alls.v_Person AS t1 ON t1.ID = t.LinkWithID AND t1.SectionID = t.SectionID AND t.StatusIs <> 2
  WHERE t.NumberIs BETWEEN 4010100000 AND 4019999999 OR t.NumberIs BETWEEN 4110100000 AND 4119999999;



GO
