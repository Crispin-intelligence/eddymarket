SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Employees].[v_VacationType]
AS
SELECT t.ID,
       t.Name,
       t.DescriptionIs,
       t.VacationAddC,
       t.VacationUseC,
       t.VacationNet,
       t.VacationDiscountedC,
	   t.VacationC,
       t.DateCreate
FROM Employees.t_VacationType AS t;



GO
