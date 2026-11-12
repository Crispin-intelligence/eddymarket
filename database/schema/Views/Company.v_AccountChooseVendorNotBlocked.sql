SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountChooseVendorNotBlocked]
AS
SELECT t.ID ,
    t.Name ,
    t.NumberF ,
    t.ShowInGymClass ,
    t.ShowInPersonalTrainer ,
    t1.Phones ,
    t1.AddressIs
  FROM Company.t_Account AS t
  LEFT JOIN Vendors.t_Vendor AS t1 ON t1.ID = t.LinkWithID AND t.SectionID = 67 AND t.IsMasterLink = 1
  WHERE t.NumberIs BETWEEN 4010100000 AND 4019999999 AND t.StatusIs <> 2;


GO
