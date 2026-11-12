SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create VIEW [Employees].[v_EmployeeTypeBase]
AS
SELECT t.ID,
       t.Name
FROM Employees.t_EmployeeType AS t;




GO
