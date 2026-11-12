SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_BonusHistory]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateIs,
       t.EmployeeID,
       t.Employee,
       t.TypeID,
       t.TypeIs,
       t.FromEmployeeID,
       t.FromEmployee,
       t.ImplementationIn,
       t.CurrencyID,
       t.Currency,
	   t.ExchangeRate,
       t.ValueIs,
       t.ValueIsF,
       t.ValueIsD,
       t.ValueIsLL,
       t.ValueIsEuro,
       t.ValueIsAR,
       t.ValueIsEN,
       t.Why,
       t.StatusIs,
       t.DateCreate
FROM Employees.t_BonusHistory AS t;




GO
