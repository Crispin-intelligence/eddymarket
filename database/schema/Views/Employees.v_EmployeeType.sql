SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_EmployeeType]
AS
SELECT t.ID,
       t.Name,
       t.DescriptionIs,
       t.EmployeeC,
       t.TeamC,
	   t.IsSync,
       t.DateCreate
FROM Employees.t_EmployeeType AS t;





GO
