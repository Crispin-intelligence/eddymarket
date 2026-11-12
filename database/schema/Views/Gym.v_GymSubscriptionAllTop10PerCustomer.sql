SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Gym].[v_GymSubscriptionAllTop10PerCustomer]
AS
SELECT o1.ID ,
    o1.Ref ,
    o1.RefF ,
    o1.DateIs ,
    o1.ToDate ,
    o1.IsActive ,
    o1.AccountID ,
    o1.SubscriptionType ,
    o1.PersonalTrainer ,
    o1.AccountEmployee ,
    o1.ClassesNames ,
    o1.ClassesEmployeesNames ,
    o1.Total ,
    o1.TotalF ,
    o1.TotalD ,
    o1.TotalLL ,
    o1.TotalEuro ,
    o1.RestLL ,
    o1.IsPaidSalary_ ,
    o1.AreClassesSalariesPaid_ ,
    o1.InHistory
  FROM ( SELECT o.ID ,
            o.Ref ,
            o.RefF ,
            o.DateIs ,
            o.ToDate ,
            o.IsActive ,
            o.AccountID ,
            o.SubscriptionType ,
            o.PersonalTrainer ,
            o.AccountEmployee ,
            o.ClassesNames ,
            o.ClassesEmployeesNames ,
            o.Total ,
            o.TotalF ,
            o.TotalD ,
            o.TotalLL ,
            o.TotalEuro ,
            o.RestLL ,
            o.IsPaidSalary_ ,
            o.AreClassesSalariesPaid_ ,
            o.InHistory ,
            ROW_NUMBER() OVER ( PARTITION BY o.AccountID ORDER BY o.DateIs DESC ) AS RowNumber
          FROM ( SELECT t.ID ,
                    t.Ref ,
                    t.RefF ,
                    t.DateIs ,
                    t.ToDate ,
                    t.IsActive ,
                    t.AccountID ,
                    t.SubscriptionType ,
                    t.PersonalTrainer ,
                    t.AccountEmployee ,
                    t.ClassesNames ,
                    t.ClassesEmployeesNames ,
                    t.Total ,
                    t.TotalF ,
                    t.TotalD ,
                    t.TotalLL ,
                    t.TotalEuro ,
                    t.RestLL ,
                    t.IsPaidSalary + 0 AS IsPaidSalary_ ,
                    t.AreClassesSalariesPaid + 0 AS AreClassesSalariesPaid_ ,
                    0 AS InHistory
                  FROM Gym.t_GymSubscription AS t
                 UNION ALL
                 SELECT t.ID ,
                    t.Ref ,
                    t.RefF ,
                    t.DateIs ,
                    t.ToDate ,
                    t.IsActive ,
                    t.AccountID ,
                    t.SubscriptionType ,
                    t.PersonalTrainer ,
                    t.AccountEmployee ,
                    t.ClassesNames ,
                    t.ClassesEmployeesNames ,
                    t.Total ,
                    t.TotalF ,
                    t.TotalD ,
                    t.TotalLL ,
                    t.TotalEuro ,
                    t.RestLL ,
                    t.IsPaidSalary + 0 AS IsPaidSalary_ ,
                    t.AreClassesSalariesPaid + 0 AS AreClassesSalariesPaid_ ,
                    1 AS InHistory
                  FROM Gym.t_GymSubscriptionHistory AS t
               ) AS o
       ) AS o1
  WHERE o1.RowNumber <= 10;









GO
