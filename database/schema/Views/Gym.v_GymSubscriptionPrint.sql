SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Gym].[v_GymSubscriptionPrint]
AS
SELECT t.ID ,
    t.RefF ,
    t.DateIs ,
    t.ToDate ,
    t.Account ,
    t2.Phones ,
    t2.AddressIs ,
    t2.IDDoor ,
    t1.BalanceF ,
    t.SubscriptionType ,
    t.PersonalTrainer ,
    t.AccountEmployee ,
    t.NumberOfClasses ,
    t.Currency ,
    t.SubscriptionTypePrice ,
    t.PersonalTrainerPrice ,
    t.Subtotal ,
    t.Discount ,
    t.TotalF ,
    t.TotalAR ,
    t.TotalEN ,
    t.Payment ,
    t.Rest ,
    t.UserIs
  FROM Gym.t_GymSubscription AS t
  INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
  LEFT JOIN Alls.v_Person AS t2 ON t2.ID = t1.LinkWithID;
  





GO
