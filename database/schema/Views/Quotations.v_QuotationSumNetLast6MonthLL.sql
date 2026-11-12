SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Quotations].[v_QuotationSumNetLast6MonthLL]
AS
SELECT t.DateMonthly AS DateOnly,
       SUM(t1.NetIsLL) AS NetIs,
       SUM(t1.Qtys) AS Qtys
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateMonthly
    FROM Quotations.t_Quotation AS s
    ORDER BY s.DateMonthly DESC
) AS t
    LEFT JOIN Quotations.t_Quotation AS t1
        ON t1.DateMonthly = t.DateMonthly
GROUP BY t.DateMonthly;






GO
