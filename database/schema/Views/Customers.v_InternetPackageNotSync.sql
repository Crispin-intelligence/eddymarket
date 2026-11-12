SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Customers].[v_InternetPackageNotSync]
AS
SELECT  t.ID ,
        t.Name ,
        t.CurrencyID ,
        t.Currency ,
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
        t.Profit ,
        t.ProfitF ,
        t.ProfitD ,
        t.ProfitLL ,
        t.ProfitEuro ,
        t.DescriptionIs ,
        t.SearchText ,
        t.DateCreate ,
        t.TotalCustomers ,
        t.TotalSubscriptions
FROM    Customers.t_InternetPackage AS t
WHERE   t.IsSync = 0;
	



GO
