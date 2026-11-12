SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_SoldSumNetYearlyLL]
AS
SELECT t.DateYearly AS DateOnly,
       SUM(t.NetIsLL) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Invoices.t_Sold AS t
GROUP BY t.DateYearly;




GO
