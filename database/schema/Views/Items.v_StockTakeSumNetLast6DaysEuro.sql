SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Items].[v_StockTakeSumNetLast6DaysEuro]
AS
SELECT t.DateOnly,
       SUM(t1.NetIsEuro) AS NetIs,
       SUM(t1.Qtys) AS Qtys
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateOnly
    FROM Items.t_StockTake AS s
    ORDER BY s.DateOnly DESC
) AS t
    LEFT JOIN Items.t_StockTake AS t1
        ON t1.DateOnly = t.DateOnly
GROUP BY t.DateOnly;





GO
