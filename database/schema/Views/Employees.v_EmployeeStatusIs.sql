SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_EmployeeStatusIs]
AS
SELECT ID,
       Name,
	   StatusIs,
	   WhyThisStatus
FROM Employees.t_Employee;



GO
