SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Quotations].[v_QuotationHistorySumNetLast6DaysLL]
AS
SELECT t.DateOnly,
       SUM(t1.NetIsLL) AS NetIs,
       SUM(t1.Qtys) AS Qtys
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateOnly
    FROM Quotations.t_QuotationHistory AS s
    ORDER BY s.DateOnly DESC
) AS t
    LEFT JOIN Quotations.t_QuotationHistory AS t1
        ON t1.DateOnly = t.DateOnly
GROUP BY t.DateOnly;




GO
