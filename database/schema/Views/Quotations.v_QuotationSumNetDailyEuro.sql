SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Quotations].[v_QuotationSumNetDailyEuro]
AS
SELECT t.DateOnly,
       SUM(t.NetIsEuro) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Quotations.t_Quotation AS t
GROUP BY t.DateOnly;



GO
