SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_Vacation]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateIs,
       t.EmployeeID,
       t.Employee,
       t.TypeID,
       t.TypeIs,
       t.DaysIs,
       t.OperationType,
       t.DescriptionIs,
       t.DateCreate
FROM Employees.t_Vacation AS t;



GO
