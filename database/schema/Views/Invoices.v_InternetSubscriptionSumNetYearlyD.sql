SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_InternetSubscriptionSumNetYearlyD]
AS
SELECT t.DateYearly AS DateOnly,
       t.Customer,
       t.InternetPackage,
       SUM(t.PriceD) AS Price,
       SUM(t.RestIsD) AS RestIs,
       COUNT(*) AS CountIs
FROM
(
    SELECT s.DateYearly,
           s.Customer,
           s.InternetPackage,
           s.PriceD,
           s.RestIsD
    FROM Invoices.t_InternetSubscription AS s
    UNION ALL
    SELECT s.DateYearly,
           s.Customer,
           s.InternetPackage,
           s.PriceD,
           s.RestIsD
    FROM Invoices.t_InternetSubscriptionHistory AS s
) AS t
GROUP BY t.DateYearly,
         t.Customer,
         t.InternetPackage;







GO
