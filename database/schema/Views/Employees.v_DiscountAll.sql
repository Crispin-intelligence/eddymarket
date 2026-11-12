SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Employees].[v_DiscountAll]
AS
SELECT t.ID,
       0 AS RowIn,
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
       t.CancelIf,
       t.StatusIs,
       t.DateCreate
FROM Employees.t_Discount AS t
UNION ALL
SELECT t.ID,
       1 AS RowIn,
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
       t.CancelIf,
       t.StatusIs,
       t.DateCreate
FROM Employees.t_DiscountHistory AS t;


GO
