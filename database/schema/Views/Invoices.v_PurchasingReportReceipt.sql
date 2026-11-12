SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE VIEW [Invoices].[v_PurchasingReportReceipt]
AS
SELECT  t.ID ,
        t.RefF ,
        t.DateIs ,
        t.UserIs ,
        t2.Name AS Vendor ,
        t.AccountVendorNumber ,
        t1.CurrencyID AS AccountCurrencyID ,
        t1.BalanceF ,
        t1.BalanceD ,
        t1.BalanceLL ,
        t1.BalanceEuro ,
        t2.Title ,
        t2.AddressIs ,
        t.CurrencyID ,
        t.ExchangeRate ,
        t.TaxExchangeRateLL ,
        t.TotalF ,
        t.DiscountIs ,
        t.DiscountIsF ,
        t.TaxRate ,
        t.TaxRateF ,
        t.TaxValueF ,
        t.NetIsF ,
        t.NetIsD ,
        t.NetIsLL ,
        t.NetIsEuro
FROM    Invoices.t_Purchasing AS t
INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountVendorID
LEFT JOIN Alls.v_Person AS t2 ON t1.SectionID = t2.SectionID
                                 AND t2.ID = t1.LinkWithID;














GO
