SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Invoices].[v_SoldReport]
AS
SELECT  t.ID ,
        t.RefF ,
        t.DateIs ,
        t.UserIs ,
        t.Salesperson + ' ' + t3.Phones AS Salesperson ,
        t2.Name AS Customer ,
        t.AccountCustomerNumber ,
        t1.CurrencyID AS AccountCurrencyID ,
        t1.BalanceF ,
        t1.BalanceD ,
        t1.BalanceLL ,
        t1.BalanceEuro ,
        t2.Phones ,
        t2.SocialMedia ,
        t2.AddressIs ,
        t2.Title ,
        t2.NumberCurrency ,
        t.CurrencyID ,
		t.ExchangeRateLL,
        t.TaxExchangeRateLL ,
        t.TotalF ,
        t.DiscountIs ,
        t.DiscountIsF ,
        t.TaxRateF ,
        t.TaxValue ,
        t.TaxValueF ,
        t.TaxValueD ,
        t.NetIsF ,
        t.NetIsAR ,
        t.NetIsEN ,
        t.DescriptionIs ,
        t.ItemHaveDiscount ,
        t.FrameJobOrderRefF
FROM    Invoices.t_Sold AS t
        LEFT JOIN Company.t_Account AS t1 ON t1.ID = t.AccountCustomerID
        LEFT JOIN Alls.v_Person AS t2 ON t1.SectionID = t2.SectionID
                                         AND t2.ID = t1.LinkWithID
        LEFT JOIN Employees.t_SalesPerson AS t3 ON t3.ID = t.SalespersonID;

















GO
