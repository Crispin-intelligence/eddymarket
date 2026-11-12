SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Gym].[v_GymActiveVSAttendance]
AS
SELECT t.ID ,
    t.DateIs ,
    t.DateMonthly ,
    t.DateYearly ,
    t.ActiveNumber ,
    t.AttendanceNumber ,
    t.IsSync
  FROM Gym.t_GymActiveVSAttendance AS t;

  
GO
