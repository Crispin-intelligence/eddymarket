SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Gym].[v_GymSubscriptionAllClassShortList]
AS
SELECT t.ID ,
    t.SubscriptionID ,
    t.ClassName ,
    t.AccountEmployee ,
    t.PriceF ,
    t.SalaryPercent ,
    t.SalaryF ,
    t.IsSalaryPaid + 0 AS IsSalaryPaid_ ,
    0 AS InHistory
  FROM Gym.t_GymSubscriptionClass AS t
UNION ALL
SELECT t.ID ,
    t.SubscriptionID ,
    t.ClassName ,
    t.AccountEmployee ,
    t.PriceF ,
    t.SalaryPercent ,
    t.SalaryF ,
    t.IsSalaryPaid + 0 AS IsSalaryPaid_ ,
    1 AS InHistory
  FROM Gym.t_GymSubscriptionHistoryClass AS t;
  

GO
