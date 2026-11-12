SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create VIEW [Employees].[v_ShiftAllList]
AS
SELECT t.ID,
       t.RefF,
       t.EmployeeID,
       t.Employee,
       t.FromIsMust,
       t.FromIs,
       t.ShiftMustF,
       t.EarlyF,
       t.CalculationEarly,
       t.LateF,
       t.LateX,
       t.LateNetF,
       t.LateExtraF,
       t.ToIsMust,
       t.ToIs,
       t.ShiftF,
       t.OverTimeF,
	   t.CalculationOverTime,
       t.OverTimeX,
       t.OverTimeNetF,
       t.OverTimeExtraF,
	   t.ShiftHourNet,
       t.ShiftNetF,
       t.TimeIncompleteF,
       t.DescriptionIs,
       t.StatusIs,
       t.DateCreate
FROM Employees.t_Shift AS t
UNION ALL
SELECT t.ID,
       t.RefF,
       t.EmployeeID,
       t.Employee,
       t.FromIsMust,
       t.FromIs,
       t.ShiftMustF,
       t.EarlyF,
       t.CalculationEarly,
       t.LateF,
       t.LateX,
       t.LateNetF,
       t.LateExtraF,
       t.ToIsMust,
       t.ToIs,
       t.ShiftF,
       t.OverTimeF,
	   t.CalculationOverTime,
       t.OverTimeX,
       t.OverTimeNetF,
       t.OverTimeExtraF,
	   t.ShiftHourNet,
       t.ShiftNetF,
       t.TimeIncompleteF,
       t.DescriptionIs,
       t.StatusIs,
       t.DateCreate
FROM Employees.t_ShiftHistory AS t;





GO
