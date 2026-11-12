SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Gym].[v_GymSubscriptionPersonalTrainerSalary]
AS
SELECT t.ID ,
    t.Ref ,
    t.RefF ,
    t.DateIs ,
    t.ToDate ,
    t.IsActive ,
    t.Account ,
    t2.ImageThumbnail ,
    t1.GymSubscriptionIsActive + 0 AS GymSubscriptionIsActive ,
    COALESCE(t2.IDDoor, -1) AS IDDoor ,
    t.SubscriptionType ,
    t.PersonalTrainer ,
    t.AccountEmployee ,
    t.PersonalTrainerPriceF ,
    t.PersonalTrainerPriceD ,
    t.PersonalTrainerPriceLL ,
    t.PersonalTrainerPriceEuro ,
    t.PersonalTrainerSalaryF ,
    t.PersonalTrainerSalaryD ,
    t.PersonalTrainerSalaryLL ,
    t.PersonalTrainerSalaryEuro ,
    t.TotalF ,
    t.TotalD ,
    t.TotalLL ,
    t.TotalEuro ,
    t.UserIs ,
    t.DescriptionIs ,
    t.DateCreate ,
    t.IsSync ,
    0 AS InHistory
  FROM Gym.t_GymSubscription AS t
  INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
  INNER JOIN Customers.t_Customer AS t2 ON t2.ID = t1.LinkWithID
  WHERE t.IsPaidSalary = 0
UNION ALL
SELECT t.ID ,
    t.Ref ,
    t.RefF ,
    t.DateIs ,
    t.ToDate ,
    t.IsActive ,
    t.Account ,
    t2.ImageThumbnail ,
    t1.GymSubscriptionIsActive + 0 AS GymSubscriptionIsActive ,
    COALESCE(t2.IDDoor, -1) AS IDDoor ,
    t.SubscriptionType ,
    t.PersonalTrainer ,
    t.AccountEmployee ,
    t.PersonalTrainerPriceF ,
    t.PersonalTrainerPriceD ,
    t.PersonalTrainerPriceLL ,
    t.PersonalTrainerPriceEuro ,
    t.PersonalTrainerSalaryF ,
    t.PersonalTrainerSalaryD ,
    t.PersonalTrainerSalaryLL ,
    t.PersonalTrainerSalaryEuro ,
    t.TotalF ,
    t.TotalD ,
    t.TotalLL ,
    t.TotalEuro ,
    t.UserIs ,
    t.DescriptionIs ,
    t.DateCreate ,
    t.IsSync ,
    1 AS InHistory
  FROM Gym.t_GymSubscriptionHistory AS t
  INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
  INNER JOIN Customers.t_Customer AS t2 ON t2.ID = t1.LinkWithID
  WHERE t.IsPaidSalary = 0;
  



GO
