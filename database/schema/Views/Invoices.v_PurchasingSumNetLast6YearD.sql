SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_PurchasingSumNetLast6YearD]
AS
SELECT t.DateYearly AS DateOnly,
       SUM(t1.NetIsD) AS NetIs,
       SUM(t1.Qtys) AS Qtys
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateYearly
    FROM Invoices.t_Purchasing AS s
    ORDER BY s.DateYearly DESC
) AS t
    LEFT JOIN Invoices.t_Purchasing AS t1
        ON t1.DateYearly = t.DateYearly
GROUP BY t.DateYearly;






GO
