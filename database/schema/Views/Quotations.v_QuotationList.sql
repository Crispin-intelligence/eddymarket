SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Quotations].[v_QuotationList]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t.RefPaper ,
        t.SaveFrom ,
        t.SoldID ,
        t.SoldRefF ,
        t.DateIs ,
        t.AccountID ,
        t.Account ,
        t.AccountNumberF ,
        t.SalespersonID ,
        t.Salesperson ,
        t.CommissionRate ,
        t.CommissionRateType ,
        t.CommissionValueF ,
        t.CommissionValueD ,
        t.AttentionTo ,
        t.SubjectIs ,
        t.Warranty ,
        t.TypeIs ,
        t.Currency ,
        t.ExchangeRate ,
        t.ExchangeRateLL ,
        t.ExchangeRateEuro ,
        t.TotalF ,
        t.TotalD ,
        t.TotalLL ,
        t.TotalEuro ,
        t.DiscountIsF ,
        t.DiscountIsD ,
        t.TaxRate ,
        t.TaxValueF ,
        t.TaxValueD ,
        t.TaxValueLL ,
        t.TaxValueEuro ,
        t.NetIsF ,
        t.NetIsD ,
        t.NetIsLL ,
        t.NetIsEuro ,
        t.ProfitF ,
        t.ProfitD ,
        t.ProfitLL ,
        t.ProfitEuro ,
        t.Qtys ,
        t.StatusIs ,
        t.WhyThisStatus ,
        t.IsConfirm ,
        t.NotificationAfterDays ,
        t.NotificationDate ,
        t.NotificationStop ,
        t.DescriptionIs ,
        t.ItemsNames ,
        t.DateCreate
FROM    Quotations.t_Quotation AS t;





















GO
DECLARE @xp int
SELECT @xp=1

GO
