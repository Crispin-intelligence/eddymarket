SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Quotations].[v_QuotationSumNetDailyD]
AS
SELECT t.DateOnly,
       SUM(t.NetIsD) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Quotations.t_Quotation AS t
GROUP BY t.DateOnly;



GO
