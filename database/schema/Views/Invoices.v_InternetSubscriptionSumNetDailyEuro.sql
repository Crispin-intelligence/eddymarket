SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_InternetSubscriptionSumNetDailyEuro]
AS
SELECT t.DateOnly,
       t.Customer,
       t.InternetPackage,
       SUM(t.PriceEuro) AS Price,
       SUM(t.RestIsEuro) AS RestIs,
       COUNT(*) AS CountIs
FROM
(
    SELECT s.DateOnly,
           s.Customer,
           s.InternetPackage,
           s.PriceEuro,
           s.RestIsEuro
    FROM Invoices.t_InternetSubscription AS s
    UNION ALL
    SELECT s.DateOnly,
           s.Customer,
           s.InternetPackage,
           s.PriceEuro,
           s.RestIsEuro
    FROM Invoices.t_InternetSubscriptionHistory AS s
) AS t
GROUP BY t.DateOnly,
         t.Customer,
         t.InternetPackage;




GO
