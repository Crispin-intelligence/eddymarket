SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Customers].[v_CustomerLastInternetSubscription]
AS
SELECT t.ID,
       t1.ID AS InternetSubscriptionID
FROM Customers.t_Customer AS t
    CROSS APPLY
(
    SELECT TOP (1)
           s.ID,
           s.ActiveTo
    FROM Invoices.t_InternetSubscription AS s
    WHERE s.CustomerID = t.ID
    ORDER BY s.ActiveTo DESC
) AS t1;


GO
