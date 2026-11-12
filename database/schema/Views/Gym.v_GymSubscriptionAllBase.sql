SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Gym].[v_GymSubscriptionAllBase]
AS
SELECT t.ID ,
    t.Ref ,
    t.RefF ,
    t.DateCreate ,
    0 AS InHistory
  FROM Gym.t_GymSubscription AS t
UNION ALL
SELECT t.ID ,
    t.Ref ,
    t.RefF ,
    t.DateCreate ,
    1 AS InHistory
  FROM Gym.t_GymSubscriptionHistory AS t;




GO
