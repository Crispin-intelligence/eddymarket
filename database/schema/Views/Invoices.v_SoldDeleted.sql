SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Invoices].[v_SoldDeleted]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t.RefPaper ,
        t.RefPurchaseOrder ,
        t.SaveFrom ,
        t.QuotationID ,
        t.QuotationRef ,
        t.InvoiceTitleID ,
        t.InvoiceTitle ,
        t.DateIs ,
        t.DateOnly ,
        t.UserID ,
        t.UserIs ,
        t.SalespersonID ,
        t.Salesperson ,
        t.CommissionRate ,
        t.CommissionRateF ,
        t.CommissionRateType ,
        t.CommissionRateOn ,
        t.StatusPayment ,
        t.CommissionValue ,
        t.CommissionValueF ,
        t.CommissionValueD ,
        t.CommissionValueLL ,
        t.CommissionValueEuro ,
        t.SalespersonTakeCommission ,
        t.CommissionAvailableValue ,
        t.CommissionAvailableValueF ,
        t.CommissionAvailableValueD ,
        t.CommissionAvailableValueLL ,
        t.CommissionAvailableValueEuro ,
        t.AccountCustomerID ,
        t.AccountCustomer ,
        t.AccountCustomerNumber ,
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
        t.Cost ,
        t.CostF ,
        t.CostD ,
        t.CostLL ,
        t.CostEuro ,
        t.Qtys ,
        t.DescriptionIs ,
        t.WFPFrom ,
        t.WFPShopID ,
        t.WFPBranchID ,
        t.WFPReported ,
        t.FrameJobOrderID ,
        t.FrameJobOrderRefF ,
        t.ItemsNames ,
        t.ItemHaveDiscount ,
        t.DateCreate
FROM    Invoices.t_SoldDeleted AS t;
















GO
