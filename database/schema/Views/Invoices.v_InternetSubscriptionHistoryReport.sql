SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Invoices].[v_InternetSubscriptionHistoryReport]
AS
SELECT  t.ID ,
        t.RefF ,
        t.DateOnly ,
        t.StartFrom ,
        t.CustomerID ,
        t.Customer ,
        t1.ID AS AccountID ,
        t2.BalanceF ,
        t.InternetPackage ,
        t.CostF ,
        t.PriceF ,
        t.PriceAR ,
        t.PriceEN ,
        t.ProfitF ,
        t.PaidF ,
        t.RestIsF ,
        t.ProfitCollectedF ,
        t.PatmentStatus
FROM    Invoices.t_InternetSubscriptionHistory AS t
INNER JOIN Customers.t_Customer AS t1 ON t1.ID = t.CustomerID
INNER JOIN Company.t_Account AS t2 ON t2.LinkWithID = t1.ID
                                      AND t2.IsMasterLink = 1;


GO
