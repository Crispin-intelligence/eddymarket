SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_VacationTop10ByType]
AS
SELECT o.ID,
       o.DateIs,
       o.Employee,
       o.TypeID,
       o.DaysIs,
       o.OperationType,
       o.DateCreate
FROM
(
    SELECT t.ID,
           t.DateIs,
           t.Employee,
           ROW_NUMBER() OVER (PARTITION BY t.TypeID ORDER BY t.DateCreate DESC) AS RowNumber,
           t.TypeID,
           t.DaysIs,
           t.OperationType,
           t.DateCreate
    FROM Employees.t_Vacation AS t
) AS o
WHERE o.RowNumber <= 10;



GO
