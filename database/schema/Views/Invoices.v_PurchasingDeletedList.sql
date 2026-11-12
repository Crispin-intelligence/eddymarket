SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_PurchasingDeletedList]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
	   t.RefPaper,
	   t.InvoiceTitle,
       t.DateIs,
       t.UserID,
       t.UserIs,
       t.AccountVendorID,
       t.AccountVendor,
       t.AccountVendorNumber,
       t.AccountBox,
       t.AccountBoxNumber,
       t.PaymentMethod,
       t.Currency,
       t.ExchangeRate,
       t.ExchangeRateLL,
       t.ExchangeRateEuro,
       t.TaxExchangeRateLL,
       t.TaxExchangeRateEuro,
       t.TotalF,
       t.TotalD,
       t.DiscountIsF,
       t.DiscountIsD,
	   t.TaxRate,
       t.TaxValueF,
       t.TaxValueD,
       t.NetIsF,
       t.NetIsD,
	   t.NetIsLL,
	   t.NetIsEuro,
       t.ProfitF,
       t.ProfitD,
	   t.FirstPaymentF,
	   t.FirstPaymentD,
	   t.SellF,
	   t.SellD,
       t.Qtys,
       t.DescriptionIs,
       t.ItemsNames,
       t.DateCreate,
	   t.IsSync
FROM Invoices.t_PurchasingDeleted AS t;













GO
