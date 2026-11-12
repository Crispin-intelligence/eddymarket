SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Quotations].[v_QuotationHistorySumNetMonthlyEuro]
AS
SELECT t.DateMonthly AS DateOnly,
       SUM(t.NetIsEuro) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Quotations.t_QuotationHistory AS t
GROUP BY t.DateMonthly;





GO
