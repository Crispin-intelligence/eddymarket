SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_ExpenseList]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t.LinkedType ,
        t.LinkID ,
        t.LinkRef ,
        t.DateIs ,
        t.UserIs ,
        t.FromAccount ,
        t.FromAccountNumberF ,
        t.ToAccount ,
        t.ToAccountNumberF ,
        t.VendorAccount ,
        t.VendorAccountNumberF ,
        t.PaymentMethod ,
        t.Currency ,
        t.ExchangeRate ,
        t.ExchangeRateLL ,
        t.ExchangeRateEuro ,
        t.TaxExchangeRateLL ,
        t.TaxExchangeRateEuro ,
        t.BalanceF ,
        t.BalanceD ,
        t.BalanceLL ,
        t.BalanceEuro ,
        t.TaxRate ,
        t.TaxValueF ,
        t.TaxValueD ,
        t.TaxValueLL ,
        t.TaxValueEuro ,
        t.NetIsF ,
        t.NetIsD ,
        t.NetIsLL ,
        t.NetIsEuro ,
        t.DescriptionIs ,
        t.DateCreate ,
        t.IsSync
FROM    Company.t_Expense AS t;













GO
