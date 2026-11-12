SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarExpense]
AS
SELECT  t.ID ,
        t.CarID ,
        t.Car ,
        t.Ref ,
        t.RefF ,
        t.DateIs ,
        t.DateOnly ,
        t.DateMonthly ,
        t.DateYearly ,
        t.ByUserID ,
        t.ByUser ,
        t.FromAccountID ,
        t.FromAccount ,
        t.FromAccountNumberF ,
        t.ToAccountID ,
        t.ToAccount ,
        t.ToAccountNumberF ,
        t.VendorAccountID ,
        t.VendorAccount ,
        t.VendorAccountNumberF ,
        t.PaymentMethod ,
        t.CurrencyID ,
        t.Currency ,
        t.ExchangeRate ,
        t.ExchangeRateLL ,
        t.ExchangeRateEuro ,
        t.TaxExchangeRateLL ,
        t.TaxExchangeRateEuro ,
        t.Balance ,
        t.BalanceF ,
        t.BalanceD ,
        t.BalanceLL ,
        t.BalanceEuro ,
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
        t.DescriptionIs ,
        t.SearchText ,
        t.DateCreate ,
        t.IsSync
FROM    Cars.t_CarExpense AS t;


GO
