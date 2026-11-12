SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Gym].[v_GymSubscriptionDeletedBase]
AS
SELECT t.ID ,
    t.Ref ,
    t.RefF ,
    t.DateCreate
  FROM Gym.t_GymSubscriptionDeleted AS t;




GO
