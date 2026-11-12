SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Quotations].[v_Quotation]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t.RefPaper ,
        t.SaveFrom ,
        t.SoldID ,
        t.SoldRefF ,
        t.DateIs ,
        t.DateOnly ,
        t.DateMonthly ,
        t.DateYearly ,
        t.AccountID ,
        t.Account ,
        t.AccountNumberF ,
        t.SalespersonID ,
        t.Salesperson ,
        t.CommissionRate ,
        t.CommissionRateF ,
        t.CommissionRateType ,
        t.CommissionValue ,
        t.CommissionValueF ,
        t.CommissionValueD ,
        t.CommissionValueLL ,
        t.CommissionValueEuro ,
        t.AttentionTo ,
        t.SubjectIs ,
        t.WarrantyID ,
        t.Warranty ,
        t.TypeID ,
        t.TypeIs ,
        t.CurrencyID ,
        t.Currency ,
        t.ExchangeRate ,
        t.ExchangeRateLL ,
        t.ExchangeRateEuro ,
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
        t.Cost ,
        t.CostF ,
        t.CostD ,
        t.CostLL ,
        t.CostEuro ,
        t.Qtys ,
        t.StatusIs ,
        t.WhyThisStatus ,
        t.IsConfirm ,
        t.NotificationAfterDays ,
        t.NotificationDate ,
        t.NotificationStop ,
        t.NotificationTextAR ,
        t.NotificationTextEN ,
        t.DescriptionIs ,
        t.ItemsNames ,
        t.ItemHaveDiscount ,
        t.DateCreate
FROM    Quotations.t_Quotation AS t;

















GO
DECLARE @xp int
SELECT @xp=2

GO
