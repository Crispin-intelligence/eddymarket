SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_SalesPersonBaseNotBlocked]
AS
SELECT t.ID,
       t.Name
FROM Employees.t_SalesPerson AS t
WHERE t.StatusIs <> 2;




GO
