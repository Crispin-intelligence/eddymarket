SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Gym].[v_GymSubscriptionAllClassSalariesStatement]
AS
SELECT  t.ID ,
        t1.DateIs ,
        t1.DateMonthly ,
        t1.DateYearly ,
        t.AccountEmployeeID ,
        t.SalaryD ,
        t.SalaryLL ,
        t.SalaryEuro ,
        t.IsSalaryPaid
FROM    Gym.t_GymSubscriptionClass AS t
INNER JOIN Gym.t_GymSubscription AS t1 ON t1.ID = t.SubscriptionID
WHERE   t.Salary <> 0
UNION ALL
SELECT  t.ID ,
        t1.DateIs ,
        t1.DateMonthly ,
        t1.DateYearly ,
        t.AccountEmployeeID ,
        t.SalaryD ,
        t.SalaryLL ,
        t.SalaryEuro ,
        t.IsSalaryPaid
FROM    Gym.t_GymSubscriptionHistoryClass AS t
INNER JOIN Gym.t_GymSubscriptionHistory AS t1 ON t1.ID = t.SubscriptionID
WHERE   t.Salary <> 0;


GO
