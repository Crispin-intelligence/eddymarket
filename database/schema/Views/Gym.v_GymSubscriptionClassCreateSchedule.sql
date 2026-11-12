SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Gym].[v_GymSubscriptionClassCreateSchedule]
AS
SELECT t.ID ,
    t.SubscriptionID ,
    t1.RefF ,
    t1.DateIs ,
    t1.ToDate ,
    t1.Account ,
    t3.ImageThumbnail ,
    COALESCE(t3.IDDoor, -1) AS IDDoor ,
    t1.SubscriptionType ,
    t.ClassID ,
    t.AccountEmployeeID
  FROM Gym.t_GymSubscriptionClass AS t
  INNER JOIN Gym.t_GymSubscription AS t1 ON t1.ID = t.SubscriptionID
  INNER JOIN Company.t_Account AS t2 ON t2.ID = t1.AccountID
  INNER JOIN Customers.t_Customer AS t3 ON t3.ID = t2.LinkWithID
  INNER JOIN Gym.t_SubscriptionType AS t4 ON t4.ID = t1.SubscriptionTypeID
  WHERE t4.TypeIs <> 0;
  
GO
