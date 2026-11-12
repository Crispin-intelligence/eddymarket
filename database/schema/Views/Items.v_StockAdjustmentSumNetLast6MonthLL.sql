SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_StockAdjustmentSumNetLast6MonthLL]
AS
SELECT t.DateMonthly AS DateOnly,
       SUM(t1.NetIsLL) AS NetIs,
       SUM(t1.Qtys) AS Qtys
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateMonthly
    FROM Items.t_StockAdjustment AS s
    ORDER BY s.DateMonthly DESC
) AS t
    LEFT JOIN Items.t_StockAdjustment AS t1
        ON t1.DateMonthly = t.DateMonthly
GROUP BY t.DateMonthly;






GO
