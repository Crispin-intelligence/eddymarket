SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_PurchasingSumNetLast6MonthEuro]
AS
SELECT t.DateMonthly AS DateOnly,
       SUM(t1.NetIsEuro) AS NetIs,
       SUM(t1.Qtys) AS Qtys
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateMonthly
    FROM Invoices.t_Purchasing AS s
    ORDER BY s.DateMonthly DESC
) AS t
    LEFT JOIN Invoices.t_Purchasing AS t1
        ON t1.DateMonthly = t.DateMonthly
GROUP BY t.DateMonthly;






GO
