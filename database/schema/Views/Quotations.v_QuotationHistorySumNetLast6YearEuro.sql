SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Quotations].[v_QuotationHistorySumNetLast6YearEuro]
AS
SELECT t.DateYearly AS DateOnly,
       SUM(t1.NetIsEuro) AS NetIs,
       SUM(t1.Qtys) AS Qtys
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateYearly
    FROM Quotations.t_QuotationHistory AS s
    ORDER BY s.DateYearly DESC
) AS t
    LEFT JOIN Quotations.t_QuotationHistory AS t1
        ON t1.DateYearly = t.DateYearly
GROUP BY t.DateYearly;






GO
