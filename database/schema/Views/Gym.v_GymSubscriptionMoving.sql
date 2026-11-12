SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Gym].[v_GymSubscriptionMoving]
AS
SELECT t.ID ,
    t.UserID ,
    t2.Name AS UserIs ,
    t.SectionID ,
    t.DateIs ,
    t.EventIs ,
    t.EventType ,
    t.ComputerIP ,
    t.Computer ,
    t.ComputerAccount ,
    t1.RefF as Name
  FROM Gym.t_GymSubscriptionMoving AS t
  LEFT OUTER JOIN Gym.t_GymSubscription AS t1 ON t1.ID = t.SectionID
  LEFT OUTER JOIN Users.t_User AS t2 ON t.UserID = t2.ID;
  





GO
