SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_InternetSubscriptionSumNetLast6MonthD]
AS
SELECT t.DateMonthly AS DateOnly,
       SUM(t1.PriceD) AS Price,
       SUM(t1.RestIsD) AS RestIs,
       COUNT(*) AS CountIs
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateMonthly
    FROM
    (
        SELECT s1.DateMonthly
        FROM Invoices.t_InternetSubscription AS s1
        UNION ALL
        SELECT s1.DateMonthly
        FROM Invoices.t_InternetSubscriptionHistory AS s1
    ) AS s
    ORDER BY s.DateMonthly DESC
) AS t
    LEFT JOIN
    (
        SELECT s1.DateMonthly,
               s1.PriceD,
               s1.RestIsD
        FROM Invoices.t_InternetSubscription AS s1
        UNION ALL
        SELECT s1.DateMonthly,
               s1.PriceD,
               s1.RestIsD
        FROM Invoices.t_InternetSubscriptionHistory AS s1
    ) AS t1
        ON t1.DateMonthly = t.DateMonthly
GROUP BY t.DateMonthly;







GO
