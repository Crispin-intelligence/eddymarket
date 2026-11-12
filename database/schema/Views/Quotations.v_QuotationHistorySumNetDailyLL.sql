SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Quotations].[v_QuotationHistorySumNetDailyLL]
AS
SELECT t.DateOnly,
       SUM(t.NetIsLL) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Quotations.t_QuotationHistory AS t
GROUP BY t.DateOnly;



GO
