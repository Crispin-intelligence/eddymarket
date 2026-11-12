SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Gym].[v_GymSubscriptionAllTypeSalariesStatement]
AS
SELECT  t.ID ,
        t.DateIs ,
        t.DateMonthly ,
        t.DateYearly ,
        t.AccountEmployeeID ,
        t.PersonalTrainerSalaryD AS PTSalaryD ,
        t.PersonalTrainerSalaryLL AS PTSalaryLL ,
        t.PersonalTrainerSalaryEuro AS PTSalaryEuro ,
        t.IsPaidSalary AS PTSalaryIsPaid ,
        0 AS ClassSalaryD ,
        0 AS ClassSalaryLL ,
        0 AS ClassSalaryEuro ,
        CONVERT(BIT, 1) AS ClassSalaryIsPaid ,
        t1.TypeIs AS CurrencyTypeIs ,
        0 AS TypeIs
FROM    Gym.t_GymSubscription AS t
INNER JOIN Currencys.t_Currency AS t1 ON t1.ID = t.CurrencyID
WHERE   t.PersonalTrainerSalary <> 0
UNION ALL
SELECT  t.ID ,
        t.DateIs ,
        t.DateMonthly ,
        t.DateYearly ,
        t.AccountEmployeeID ,
        t.PersonalTrainerSalaryD AS PTSalaryD ,
        t.PersonalTrainerSalaryLL AS PTSalaryLL ,
        t.PersonalTrainerSalaryEuro AS PTSalaryEuro ,
        t.IsPaidSalary AS PTSalaryIsPaid ,
        0 AS ClassSalaryD ,
        0 AS ClassSalaryLL ,
        0 AS ClassSalaryEuro ,
        CONVERT(BIT, 1) AS ClassSalaryIsPaid ,
        t1.TypeIs AS CurrencyTypeIs ,
        0 AS TypeIs
FROM    Gym.t_GymSubscriptionHistory AS t
INNER JOIN Currencys.t_Currency AS t1 ON t1.ID = t.CurrencyID
WHERE   t.PersonalTrainerSalary <> 0
UNION ALL
SELECT  t.ID ,
        t1.DateIs ,
        t1.DateMonthly ,
        t1.DateYearly ,
        t.AccountEmployeeID ,
        0 AS PTSalaryD ,
        0 AS PTSalaryLL ,
        0 AS PTSalaryEuro ,
        CONVERT(BIT, 1) AS PTSalaryIsPaid ,
        t.SalaryD AS ClassSalaryD ,
        t.SalaryLL AS ClassSalaryLL ,
        t.SalaryEuro AS ClassSalaryEuro ,
        t.IsSalaryPaid AS ClassSalaryIsPaid ,
        t2.TypeIs AS CurrencyTypeIs ,
        1 AS TypeIs
FROM    Gym.t_GymSubscriptionClass AS t
INNER JOIN Gym.t_GymSubscription AS t1 ON t1.ID = t.SubscriptionID
INNER JOIN Currencys.t_Currency AS t2 ON t2.ID = t1.CurrencyID
WHERE   t.Salary <> 0
UNION ALL
SELECT  t.ID ,
        t1.DateIs ,
        t1.DateMonthly ,
        t1.DateYearly ,
        t.AccountEmployeeID ,
        0 AS PTSalaryD ,
        0 AS PTSalaryLL ,
        0 AS PTSalaryEuro ,
        CONVERT(BIT, 1) AS PTSalaryIsPaid ,
        t.SalaryD AS ClassSalaryD ,
        t.SalaryLL AS ClassSalaryLL ,
        t.SalaryEuro AS ClassSalaryEuro ,
        t.IsSalaryPaid AS ClassSalaryIsPaid ,
        t2.TypeIs AS CurrencyTypeIs ,
        1 AS TypeIs
FROM    Gym.t_GymSubscriptionHistoryClass AS t
INNER JOIN Gym.t_GymSubscriptionHistory AS t1 ON t1.ID = t.SubscriptionID
INNER JOIN Currencys.t_Currency AS t2 ON t2.ID = t1.CurrencyID
WHERE   t.Salary <> 0;




GO
