SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_InternetSubscriptionSumNetLast6YearD]
AS
SELECT t.DateYearly AS DateOnly,
       SUM(t1.PriceD) AS Price,
       SUM(t1.RestIsD) AS RestIs,
       COUNT(*) AS CountIs
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateYearly
    FROM
    (
        SELECT s1.DateYearly
        FROM Invoices.t_InternetSubscription AS s1
        UNION ALL
        SELECT s1.DateYearly
        FROM Invoices.t_InternetSubscriptionHistory AS s1
    ) AS s
    ORDER BY s.DateYearly DESC
) AS t
    LEFT JOIN
    (
        SELECT s1.DateYearly,
               s1.PriceD,
               s1.RestIsD
        FROM Invoices.t_InternetSubscription AS s1
        UNION ALL
        SELECT s1.DateYearly,
               s1.PriceD,
               s1.RestIsD
        FROM Invoices.t_InternetSubscriptionHistory AS s1
    ) AS t1
        ON t1.DateYearly = t.DateYearly
GROUP BY t.DateYearly;







GO
