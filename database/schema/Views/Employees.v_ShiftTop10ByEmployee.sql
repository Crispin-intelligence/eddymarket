SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_ShiftTop10ByEmployee]
AS
SELECT o1.FromTable,
       o1.ID,
       o1.EmployeeID,
       o1.FromIs,
       o1.ToIs,
       o1.ShiftMustF,
       o1.ShiftNetF,
       o1.DateCreate
FROM
(
    SELECT o.FromTable,
           o.ID,
           o.EmployeeID,
           o.FromIs,
           o.ToIs,
           o.ShiftMustF,
           o.ShiftNetF,
           o.DateCreate,
           ROW_NUMBER() OVER (PARTITION BY o.EmployeeID ORDER BY o.DateCreate DESC) AS RowNumber
    FROM
    (
        SELECT 0 AS FromTable,
               t.ID,
               t.EmployeeID,
               t.FromIs,
               t.ToIs,
               t.ShiftMustF,
               t.ShiftNetF,
               t.DateCreate
        FROM Employees.t_Shift AS t
        UNION ALL
        SELECT 1 AS FromTable,
               t.ID,
               t.EmployeeID,
               t.FromIs,
               t.ToIs,
               t.ShiftMustF,
               t.ShiftNetF,
               t.DateCreate
        FROM Employees.t_ShiftHistory AS t
		WHERE t.StatusIs <> 2
    ) AS o
) AS o1
WHERE o1.RowNumber <= 10;




GO
