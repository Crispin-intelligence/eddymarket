SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Quotations].[v_QuotationHistorySumNetLast6MonthD]
AS
SELECT t.DateMonthly AS DateOnly,
       SUM(t1.NetIsD) AS NetIs,
       SUM(t1.Qtys) AS Qtys
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateMonthly
    FROM Quotations.t_QuotationHistory AS s
    ORDER BY s.DateMonthly DESC
) AS t
    LEFT JOIN Quotations.t_QuotationHistory AS t1
        ON t1.DateMonthly = t.DateMonthly
GROUP BY t.DateMonthly;






GO
