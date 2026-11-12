SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Employees].[f_TeamsGetMembersName] ( @SectionID int ) RETURNS NVARCHAR(max)
AS
BEGIN

DECLARE @OutPut VARCHAR(MAX)

SELECT @OutPut =  COALESCE(@OutPut + ' , ' ,'') + t2.Name
FROM Employees.t_TeamsMembers AS t LEFT JOIN Employees.t_Employee AS t2 ON t.EmployeeID = t2.id
WHERE t.TeamID = @SectionID

RETURN ISNULL( @OutPut , N'')

END





GO
