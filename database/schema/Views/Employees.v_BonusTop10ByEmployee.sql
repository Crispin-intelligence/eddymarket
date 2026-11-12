SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_BonusTop10ByEmployee]
AS
SELECT o1.FromTable,
       o1.ID,
       o1.EmployeeID,
       o1.TypeID,
       o1.TypeIs,
       o1.ImplementationIn,
       o1.ValueIsF,
       o1.StatusIs,
       o1.DateCreate
FROM
(
    SELECT o.FromTable,
           o.ID,
           o.EmployeeID,
           o.TypeID,
           o.TypeIs,
           o.ImplementationIn,
           o.ValueIsF,
           o.StatusIs,
           o.DateCreate,
           ROW_NUMBER() OVER (PARTITION BY o.EmployeeID ORDER BY o.DateCreate DESC) AS RowNumber
    FROM
    (
        SELECT 0 AS FromTable,
               t.ID,
               t.EmployeeID,
               t.TypeID,
               t.TypeIs,
               t.ImplementationIn,
               t.ValueIsF,
               t.StatusIs,
               t.DateCreate
        FROM Employees.t_Bonus AS t
        UNION ALL
        SELECT 1 AS FromTable,
               t.ID,
               t.EmployeeID,
               t.TypeID,
               t.TypeIs,
               t.ImplementationIn,
               t.ValueIsF,
               t.StatusIs,
               t.DateCreate
        FROM Employees.t_BonusHistory AS t
    ) AS o
) AS o1
WHERE o1.RowNumber <= 10;





GO
