SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Employees].[v_TeamsMembers]
AS
SELECT t.ID,
       t.TeamID,
       t.EmployeeID,
       t.Description
FROM Employees.t_TeamsMembers AS t;





GO
