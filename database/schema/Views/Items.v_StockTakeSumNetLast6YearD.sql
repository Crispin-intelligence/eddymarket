SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_StockTakeSumNetLast6YearD]
AS
SELECT t.DateYearly AS DateOnly,
       SUM(t1.NetIsD) AS NetIs,
       SUM(t1.Qtys) AS Qtys
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateYearly
    FROM Items.t_StockTake AS s
    ORDER BY s.DateYearly DESC
) AS t
    LEFT JOIN Items.t_StockTake AS t1
        ON t1.DateYearly = t.DateYearly
GROUP BY t.DateYearly;







GO
