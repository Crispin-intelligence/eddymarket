SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_InternetSubscriptionSumNetLast6MonthEuro]
AS
SELECT t.DateMonthly AS DateOnly,
       SUM(t1.PriceEuro) AS Price,
       SUM(t1.RestIsEuro) AS RestIs,
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
               s1.PriceEuro,
               s1.RestIsEuro
        FROM Invoices.t_InternetSubscription AS s1
        UNION ALL
        SELECT s1.DateMonthly,
               s1.PriceEuro,
               s1.RestIsEuro
        FROM Invoices.t_InternetSubscriptionHistory AS s1
    ) AS t1
        ON t1.DateMonthly = t.DateMonthly
GROUP BY t.DateMonthly;







GO
