SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_SoldSumNetMonthlyD]
AS
SELECT t.DateMonthly AS DateOnly,
       SUM(t.NetIsD) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Invoices.t_Sold AS t
GROUP BY t.DateMonthly;




GO
