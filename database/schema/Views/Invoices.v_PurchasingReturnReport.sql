SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Invoices].[v_PurchasingReturnReport]
AS
SELECT t.ID,
       t.RefF,
       t.DateIs,
       t.UserIs,
       t2.Name AS Vendor,
       t.AccountVendorNumber,
	   t1.CurrencyID AS AccountCurrencyID,
       t1.BalanceF,
	   t1.BalanceD,
	   t1.BalanceLL,
	   t1.BalanceEuro,
       t2.Phones,
        t2.SocialMedia ,
       t2.AddressIs,
	   t2.Title,
       t2.NumberCurrency,
	   t.CurrencyID,
       t.ExchangeRate,
       t.ExchangeRateLL,
       t.ExchangeRateEuro,
       t.TaxExchangeRateLL,
       t.TaxExchangeRateEuro,
       t.TotalF,
       t.DiscountIs,
       t.DiscountIsF,
	   t.TaxRateF,
       t.TaxValue,
       t.TaxValueF,
       t.TaxValueD,
       t.NetIsF,
       t.NetIsAR,
       t.NetIsEN,
       t.DescriptionIs,
	   t.ItemHaveDiscount
FROM Invoices.t_PurchasingReturn AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.AccountVendorID
    LEFT JOIN Alls.v_Person AS t2
        ON t1.SectionID = t2.SectionID
           AND t2.ID = t1.LinkWithID;















GO
