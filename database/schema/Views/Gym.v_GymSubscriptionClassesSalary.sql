SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Gym].[v_GymSubscriptionClassesSalary]
AS
SELECT t.ID ,
    t.SubscriptionID ,
    t1.Ref ,
    t1.RefF ,
    t1.DateIs ,
    t1.ToDate ,
    t1.IsActive ,
    t1.AccountID ,
    t1.Account ,
    t3.ImageThumbnail ,
    t2.GymSubscriptionIsActive + 0 AS GymSubscriptionIsActive ,
    COALESCE(t3.IDDoor, -1) AS IDDoor ,
    t1.SubscriptionTypeID ,
    t1.SubscriptionType ,
    t.ClassID ,
    t.ClassName ,
    t.AccountEmployeeID ,
    t.AccountEmployee ,
    t.PriceF ,
    t.PriceD ,
    t.PriceLL ,
    t.PriceEuro ,
    t.SalaryF ,
    t.SalaryD ,
    t.SalaryLL ,
    t.SalaryEuro ,
    t1.TotalF ,
    t1.TotalD ,
    t1.TotalLL ,
    t1.TotalEuro ,
    t1.UserID ,
    t1.UserIs ,
    t1.DescriptionIs ,
    t1.DateCreate ,
    t1.IsSync ,
    0 AS InHistory
  FROM Gym.t_GymSubscriptionClass AS t
  INNER JOIN Gym.t_GymSubscription AS t1 ON t1.ID = t.SubscriptionID
  INNER JOIN Company.t_Account AS t2 ON t2.ID = t1.AccountID
  INNER JOIN Customers.t_Customer AS t3 ON t3.ID = t2.LinkWithID
  WHERE t.IsSalaryPaid = 0
UNION ALL
SELECT t.ID ,
    t.SubscriptionID ,
    t1.Ref ,
    t1.RefF ,
    t1.DateIs ,
    t1.ToDate ,
    t1.IsActive ,
    t1.AccountID ,
    t1.Account ,
    t3.ImageThumbnail ,
    t2.GymSubscriptionIsActive + 0 AS GymSubscriptionIsActive ,
    COALESCE(t3.IDDoor, -1) AS IDDoor ,
    t1.SubscriptionTypeID ,
    t1.SubscriptionType ,
    t.ClassID ,
    t.ClassName ,
    t.AccountEmployeeID ,
    t.AccountEmployee ,
    t.PriceF ,
    t.PriceD ,
    t.PriceLL ,
    t.PriceEuro ,
    t.SalaryF ,
    t.SalaryD ,
    t.SalaryLL ,
    t.SalaryEuro ,
    t1.TotalF ,
    t1.TotalD ,
    t1.TotalLL ,
    t1.TotalEuro ,
    t1.UserID ,
    t1.UserIs ,
    t1.DescriptionIs ,
    t1.DateCreate ,
    t1.IsSync ,
    1 AS InHistory
  FROM Gym.t_GymSubscriptionHistoryClass AS t
  INNER JOIN Gym.t_GymSubscriptionHistory AS t1 ON t1.ID = t.SubscriptionID
  INNER JOIN Company.t_Account AS t2 ON t2.ID = t1.AccountID
  INNER JOIN Customers.t_Customer AS t3 ON t3.ID = t2.LinkWithID
  WHERE t.IsSalaryPaid = 0;
  
  


GO
