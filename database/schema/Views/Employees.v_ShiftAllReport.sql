SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_ShiftAllReport]
AS
SELECT t.ID,
       t.EmployeeID,
       t.DateIs,
       t.FromIs,
       t.LateMinuteNet,
       t.LateNetF,
       t.ToIs,
       t.OverTimeMinuteNet,
       t.OverTimeNetF,
       t.ShiftMinuteNet,
       t.ShiftNetF,
       t.TimeIncompleteMinute,
       t.TimeIncompleteF
FROM Employees.t_Shift AS t
WHERE t.StatusIs <> 2 
UNION ALL
SELECT t.ID,
       t.EmployeeID,
       t.DateIs,
       t.FromIs,
       t.LateMinuteNet,
       t.LateNetF,
       t.ToIs,
       t.OverTimeMinuteNet,
       t.OverTimeNetF,
       t.ShiftMinuteNet,
       t.ShiftNetF,
       t.TimeIncompleteMinute,
       t.TimeIncompleteF
FROM Employees.t_ShiftHistory AS t
WHERE t.StatusIs <> 2 ;




GO
