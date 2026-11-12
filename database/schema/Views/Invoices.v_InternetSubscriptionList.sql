SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Invoices].[v_InternetSubscriptionList]
AS
    SELECT  t.ID ,
            t.Ref ,
            t.RefF ,
            t.DateOnly ,
            t.StartFrom ,
            t.ActiveTo ,
            t.CustomerID ,
            t.Customer ,
            t1.EmployeeInternet ,
            t.AccountSale ,
            t.AccountSaleNumberF ,
            t.AccountBox ,
            t.AccountBoxNumberF ,
            t.InternetPackage ,
            t.Currency ,
            t.ExchangeRate ,
            t.CostF ,
            t.CostD ,
            t.CostLL ,
            t.CostEuro ,
            t.PriceF ,
            t.PriceD ,
            t.PriceLL ,
            t.PriceEuro ,
            t.ProfitF ,
            t.ProfitD ,
            t.ProfitLL ,
            t.ProfitEuro ,
            t.PaidF ,
            t.PaidD ,
            t.PaidLL ,
            t.PaidEuro ,
            t.RestIsF ,
            t.RestIsD ,
            t.RestIsLL ,
            t.RestIsEuro ,
            t.ProfitCollectedF ,
            t.ProfitCollectedD ,
            t.ProfitCollectedLL ,
            t.ProfitCollectedEuro ,
            t.PatmentStatus ,
            t.DescriptionIs ,
            t.DateCreate
    FROM    Invoices.t_InternetSubscription AS t
            LEFT JOIN Customers.t_Customer AS t1 ON t1.ID = t.CustomerID;








GO
