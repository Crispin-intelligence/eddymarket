SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Invoices].[v_SoldReturnSumNetMonthlyD]
AS
SELECT t.DateMonthly AS DateOnly,
       SUM(t.NetIsD) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Invoices.t_SoldReturn AS t
GROUP BY t.DateMonthly;





GO
