SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Gym].[v_GymSubscriptionAllSalariesStatement]
AS
SELECT  t.ID ,
        t.DateIs ,
        t.DateMonthly ,
        t.DateYearly ,
        t.AccountEmployeeID ,
        t.PersonalTrainerSalaryD ,
        t.PersonalTrainerSalaryLL ,
        t.PersonalTrainerSalaryEuro ,
        t.IsPaidSalary
FROM    Gym.t_GymSubscription AS t
WHERE   t.PersonalTrainerSalary <> 0
UNION ALL
SELECT  t.ID ,
        t.DateIs ,
        t.DateMonthly ,
        t.DateYearly ,
        t.AccountEmployeeID ,
        t.PersonalTrainerSalaryD ,
        t.PersonalTrainerSalaryLL ,
        t.PersonalTrainerSalaryEuro ,
        t.IsPaidSalary
FROM    Gym.t_GymSubscriptionHistory AS t
WHERE   t.PersonalTrainerSalary <> 0;


GO
