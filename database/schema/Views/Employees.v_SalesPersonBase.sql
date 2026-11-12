SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Employees].[v_SalesPersonBase]
AS
SELECT ID,
       Name
FROM Employees.t_SalesPerson;



GO
