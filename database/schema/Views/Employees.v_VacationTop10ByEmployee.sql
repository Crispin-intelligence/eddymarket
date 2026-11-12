SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_VacationTop10ByEmployee]
AS
SELECT o.ID,
       o.DateIs,
       o.EmployeeID,
       o.TypeIs,
       o.DaysIs,
       o.OperationType,
       o.DateCreate
FROM
(
    SELECT t.ID,
           t.DateIs,
		   t.EmployeeID,
           ROW_NUMBER() OVER (PARTITION BY t.EmployeeID ORDER BY t.DateCreate DESC) AS RowNumber,
           t.TypeIs,
           t.DaysIs,
           t.OperationType,
           t.DateCreate
    FROM Employees.t_Vacation AS t
) AS o
WHERE o.RowNumber <= 10;




GO
