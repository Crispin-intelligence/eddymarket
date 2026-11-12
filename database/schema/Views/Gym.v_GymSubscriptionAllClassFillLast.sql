SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Gym].[v_GymSubscriptionAllClassFillLast]
AS
SELECT t.ID ,
    t.SubscriptionID ,
    t.ClassID ,
    t.ClassName ,
    t.AccountEmployeeID ,
    t.AccountEmployee ,
    t1.CurrencyID ,
    t.Price ,
    t.SalaryPercent ,
    t.Salary ,
    t.DescriptionIs
  FROM Gym.t_GymSubscriptionClass AS t
  INNER JOIN Gym.t_GymSubscription AS t1 ON t1.ID = t.SubscriptionID
UNION ALL
SELECT t.ID ,
    t.SubscriptionID ,
    t.ClassID ,
    t.ClassName ,
    t.AccountEmployeeID ,
    t.AccountEmployee ,
    t1.CurrencyID ,
    t.Price ,
    t.SalaryPercent ,
    t.Salary ,
    t.DescriptionIs
  FROM Gym.t_GymSubscriptionHistoryClass AS t
  INNER JOIN Gym.t_GymSubscriptionHistory AS t1 ON t1.ID = t.SubscriptionID;


GO
