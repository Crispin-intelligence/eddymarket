SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_PurchasingReturnNotSync]
AS
SELECT t.ID ,
       t.Ref ,
       t.RefF ,
       t.RefPaper ,
       t.InvoiceTitleID ,
       t.InvoiceTitle ,
       t.DateIs ,
       t.DateOnly ,
       t.DateMonthly ,
       t.DateYearly ,
       t.UserID ,
       t.UserIs ,
       t.AccountVendorID ,
       t.AccountVendor ,
       t.AccountVendorNumber ,
       t.AccountBoxID ,
       t.AccountBox ,
       t.AccountBoxNumber ,
       t.PaymentMethod ,
       t.CurrencyID ,
       t.Currency ,
       t.ExchangeRate ,
       t.ExchangeRateLL ,
       t.ExchangeRateEuro ,
       t.TaxExchangeRateLL ,
       t.TaxExchangeRateEuro ,
       t.Total ,
       t.TotalF ,
       t.TotalD ,
       t.TotalLL ,
       t.TotalEuro ,
       t.DiscountIs ,
       t.DiscountIsF ,
       t.DiscountIsD ,
       t.DiscountIsLL ,
       t.DiscountIsEuro ,
       t.TaxRate ,
       t.TaxRateF ,
       t.TaxValue ,
       t.TaxValueF ,
       t.TaxValueD ,
       t.TaxValueLL ,
       t.TaxValueEuro ,
       t.NetIs ,
       t.NetIsF ,
       t.NetIsD ,
       t.NetIsLL ,
       t.NetIsEuro ,
       t.NetIsAR ,
       t.NetIsEN ,
       t.Profit ,
       t.ProfitF ,
       t.ProfitD ,
       t.ProfitLL ,
       t.ProfitEuro ,
       t.FirstPayment ,
       t.FirstPaymentF ,
       t.FirstPaymentD ,
       t.FirstPaymentLL ,
       t.FirstPaymentEuro ,
       t.Sell ,
       t.SellF ,
       t.SellD ,
       t.SellLL ,
       t.SellEuro ,
       t.Qtys ,
       t.DescriptionIs ,
       t.ItemsNames ,
       t.ItemHaveDiscount ,
       t.DateCreate
FROM Invoices.t_PurchasingReturn AS t
WHERE t.IsSync = 0;












GO
