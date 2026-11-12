SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_PurchasingReturnSumNetLast6DaysD]
AS
SELECT t.DateOnly,
       SUM(t1.NetIsD) AS NetIs,
       SUM(t1.Qtys) AS Qtys
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateOnly
    FROM Invoices.t_PurchasingReturn AS s
    ORDER BY s.DateOnly DESC
) AS t
    LEFT JOIN Invoices.t_PurchasingReturn AS t1
        ON t1.DateOnly = t.DateOnly
GROUP BY t.DateOnly;




GO
