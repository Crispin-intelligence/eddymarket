SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_VacationBase]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
	   t.DateCreate
FROM Employees.t_Vacation AS t;



GO
