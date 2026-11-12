SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Quotations].[v_QuotationSumNetYearlyEuro]
AS
SELECT t.DateYearly AS DateOnly,
       SUM(t.NetIsEuro) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Quotations.t_Quotation AS t
GROUP BY t.DateYearly;





GO
