SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create VIEW [Employees].[v_EmployeeBase]
AS
SELECT ID,
       Name
FROM Employees.t_Employee;


GO
