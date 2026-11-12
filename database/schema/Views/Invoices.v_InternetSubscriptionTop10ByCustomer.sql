SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_InternetSubscriptionTop10ByCustomer]
AS
SELECT o.ID,
       o.CustomerID,
       o.ActiveTo,
       o.InternetPackage,
       o.PriceF,
       o.RestIsF
FROM
(
    SELECT t.ID,
           t.CustomerID,
           t.ActiveTo,
           t.InternetPackage,
           t.PriceF,
           t.RestIsF,
           ROW_NUMBER() OVER (PARTITION BY t.CustomerID ORDER BY t.ActiveTo DESC) AS RowNumber
    FROM
    (
        SELECT s.ID,
               s.CustomerID,
               s.ActiveTo,
               s.InternetPackage,
               s.PriceF,
               s.RestIsF
        FROM Invoices.t_InternetSubscription AS s
        UNION ALL
        SELECT s.ID,
               s.CustomerID,
               s.ActiveTo,
               s.InternetPackage,
               s.PriceF,
               s.RestIsF
        FROM Invoices.t_InternetSubscriptionHistory AS s
    ) AS t
) AS o
WHERE o.RowNumber <= 10;







GO
