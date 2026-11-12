SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_PurchasingSumNetMonthlyEuro]
AS
SELECT t.DateMonthly AS DateOnly,
       SUM(t.NetIsEuro) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Invoices.t_Purchasing AS t
GROUP BY t.DateMonthly;





GO
