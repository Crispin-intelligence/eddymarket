SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Gym].[v_GymSubscriptionCountAndTotal]
AS
SELECT t.DateIs ,
    t.SubscriptionType ,
    t.PersonalTrainer ,
    t.AccountEmployee ,
    t.ClassesNames ,
    t.ClassesEmployeesNames ,
    t.TotalD ,
    t.TotalLL ,
    t.TotalEuro
  FROM Gym.t_GymSubscription AS t;
  





GO
