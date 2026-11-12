SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Gym].[v_GymSubscriptionHistoryBase]
AS
SELECT t.ID ,
    t.Ref ,
    t.RefF ,
    t.DateCreate
  FROM Gym.t_GymSubscriptionHistory AS t;




GO
