SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_EmployeePayrollNotBlocked]
AS
SELECT t.ID,
       t.Name,
	   t.DateWork,
       t.IDFingerPrint,
       t.CurrencyID,
       t.Currency,
       t.SalaryIs,
       t.SalaryIsF,
       t.DaysWork,
       t.DaysWorkHours,
       t.TotalHoursFree,
       t.TotalHoursMustWork,
       t.SalaryHours,
       t.SalaryHoursF,
	   t.SalaryDeliveryService,
	   t.SalaryDeliveryServiceF,
       t.VacationDay,
       t.HoursLateX,
       t.HoursOverX,
       t.CalculationEarly,
       t.CalculationOverTime,
       t.ShiftFrom,
       t.ShiftTo
FROM Employees.t_Employee AS t
WHERE t.StatusIs <> 2;



GO
