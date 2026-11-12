SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_InternetSubscriptionHistory]
AS
    SELECT  t.ID ,
            t.Ref ,
            t.RefF ,
            t.DateIs ,
            t.DateOnly ,
            t.DateMonthly ,
            t.DateYearly ,
            t.StartFrom ,
            t.ActiveTo ,
            t.CustomerID ,
            t.Customer ,
            t1.EmployeeIDInternet ,
            t1.EmployeeInternet ,
            t.AccountSaleID ,
            t.AccountSale ,
            t.AccountSaleNumberF ,
            t.AccountBoxID ,
            t.AccountBox ,
            t.AccountBoxNumberF ,
            t.InternetPackageID ,
            t.InternetPackage ,
            t.CurrencyID ,
            t.Currency ,
            t.ExchangeRate ,
            t.Cost ,
            t.CostF ,
            t.CostD ,
            t.CostLL ,
            t.CostEuro ,
            t.Price ,
            t.PriceF ,
            t.PriceD ,
            t.PriceLL ,
            t.PriceEuro ,
            t.PriceAR ,
            t.PriceEN ,
            t.Profit ,
            t.ProfitF ,
            t.ProfitD ,
            t.ProfitLL ,
            t.ProfitEuro ,
            t.Paid ,
            t.PaidF ,
            t.PaidD ,
            t.PaidLL ,
            t.PaidEuro ,
            t.RestIs ,
            t.RestIsF ,
            t.RestIsD ,
            t.RestIsLL ,
            t.RestIsEuro ,
            t.ProfitCollected ,
            t.ProfitCollectedF ,
            t.ProfitCollectedD ,
            t.ProfitCollectedLL ,
            t.ProfitCollectedEuro ,
            t.PatmentStatus ,
            t.DescriptionIs ,
            t.DateCreate
    FROM    Invoices.t_InternetSubscriptionHistory AS t
            LEFT JOIN Customers.t_Customer AS t1 ON t1.ID = t.CustomerID;










GO
