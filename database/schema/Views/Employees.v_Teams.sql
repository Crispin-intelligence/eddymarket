SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_Teams]
AS
    SELECT  t.ID ,
            t.Name ,
            t.TypeID ,
            t.EmployeeID ,
            t.Description ,
            Employees.f_TeamsGetMembersName(t.ID) AS Members
    FROM    Employees.t_Teams AS t





GO
