SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_StockAdjustmentSumNetLast6DaysLL]
AS
SELECT t.DateOnly,
       SUM(t1.NetIsLL) AS NetIs,
       SUM(t1.Qtys) AS Qtys
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateOnly
    FROM Items.t_StockAdjustment AS s
    ORDER BY s.DateOnly DESC
) AS t
    LEFT JOIN Items.t_StockAdjustment AS t1
        ON t1.DateOnly = t.DateOnly
GROUP BY t.DateOnly;




GO
