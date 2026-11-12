SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_BonusHistoryList]
AS
SELECT t.ID,
       t.RefF,
       t.DateIs,
       t.EmployeeID,
       t.Employee,
       t.TypeID,
       t.TypeIs,
       t.FromEmployee,
       t.ImplementationIn,
       t.Currency,
	   t.ExchangeRate,
       t.ValueIsF,
       t.ValueIsD,
       t.ValueIsLL,
       t.ValueIsEuro,
       t.Why,
       t.StatusIs,
       t.DateCreate
FROM Employees.t_BonusHistory AS t;




GO
