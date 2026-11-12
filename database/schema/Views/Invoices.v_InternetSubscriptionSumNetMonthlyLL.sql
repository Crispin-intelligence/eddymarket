SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_InternetSubscriptionSumNetMonthlyLL]
AS
SELECT t.DateMonthly AS DateOnly,
       t.Customer,
       t.InternetPackage,
       SUM(t.PriceLL) AS Price,
       SUM(t.RestIsLL) AS RestIs,
       COUNT(*) AS CountIs
FROM
(
    SELECT s.DateMonthly,
           s.Customer,
           s.InternetPackage,
           s.PriceLL,
           s.RestIsLL
    FROM Invoices.t_InternetSubscription AS s
    UNION ALL
    SELECT s.DateMonthly,
           s.Customer,
           s.InternetPackage,
           s.PriceLL,
           s.RestIsLL
    FROM Invoices.t_InternetSubscriptionHistory AS s
) AS t
GROUP BY t.DateMonthly,
         t.Customer,
         t.InternetPackage;



GO
