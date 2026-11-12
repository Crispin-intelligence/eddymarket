SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_SoldReturnSumNetDailyEuro]
AS
SELECT t.DateOnly,
       SUM(t.NetIsEuro) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Invoices.t_SoldReturn AS t
GROUP BY t.DateOnly;



GO
