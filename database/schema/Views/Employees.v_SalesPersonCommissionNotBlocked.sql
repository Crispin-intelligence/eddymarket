SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_SalesPersonCommissionNotBlocked]
AS
SELECT t.ID,
       t.Name,
       t.CommissionRate,
       t.CommissionRateType,
       t.CommissionRateOn
FROM Employees.t_SalesPerson AS t
WHERE t.StatusIs <> 2;




GO
