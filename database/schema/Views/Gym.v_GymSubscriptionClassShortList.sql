SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Gym].[v_GymSubscriptionClassShortList]
AS
SELECT t.ID ,
    t.SubscriptionID ,
    t.ClassName ,
    t.AccountEmployee ,
    t.PriceF ,
    t.SalaryPercent ,
    t.SalaryF ,
    t.IsSalaryPaid + 0 AS IsSalaryPaid_
  FROM Gym.t_GymSubscriptionClass AS t;





GO
