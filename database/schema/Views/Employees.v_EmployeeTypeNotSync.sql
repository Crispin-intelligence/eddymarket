SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_EmployeeTypeNotSync]
AS
SELECT t.ID ,
       t.Name ,
       t.DescriptionIs ,
       t.EmployeeC ,
       t.TeamC ,
       t.SearchText ,
       t.DateCreate
FROM Employees.t_EmployeeType AS t
WHERE t.IsSync = 0;







GO
