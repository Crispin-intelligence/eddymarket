SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Gym].[v_GymMemberAttendance]
AS
SELECT t.ID ,
    t.DateIs ,
    t.DateOnly ,
    t.DateMonthly ,
    t.DateYearly ,
    t.AccountID ,
    t.Account ,
    t.AccountNumber ,
    t.TypeIs ,
    t.TypeIsAR ,
    t.TypeIsEN ,
    t.DescriptionIs ,
    t.DateCreate ,
    t.IsSync
  FROM Gym.t_GymMemberAttendance AS t;
  





GO
