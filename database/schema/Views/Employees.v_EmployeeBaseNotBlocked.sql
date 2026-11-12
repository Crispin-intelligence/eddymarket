SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Employees].[v_EmployeeBaseNotBlocked]
AS
SELECT t.ID,
       t.Name
FROM Employees.t_Employee AS t
WHERE t.StatusIs <> 2;



GO
