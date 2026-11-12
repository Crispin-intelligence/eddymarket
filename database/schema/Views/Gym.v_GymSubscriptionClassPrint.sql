SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Gym].[v_GymSubscriptionClassPrint]
AS
SELECT t.ID ,
    t.SubscriptionID ,
    t.ClassName ,
    t.AccountEmployee ,
    t.Price
  FROM Gym.t_GymSubscriptionClass AS t;



GO
