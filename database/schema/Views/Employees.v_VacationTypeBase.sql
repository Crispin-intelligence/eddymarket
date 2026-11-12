SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create VIEW [Employees].[v_VacationTypeBase]
AS
SELECT t.ID,
       t.Name
FROM Employees.t_VacationType AS t;





GO
