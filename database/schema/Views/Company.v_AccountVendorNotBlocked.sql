SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_AccountVendorNotBlocked]
AS
SELECT t.ID ,
    t.Name ,
    t.NumberF ,
    t.ShowInGymClass ,
    t.ShowInPersonalTrainer
  FROM Company.t_Account AS t
  WHERE t.StatusIs <> 2 AND ( t.NumberIs BETWEEN 4010100000 AND 4010199999 );





GO
