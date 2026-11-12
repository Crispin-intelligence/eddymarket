SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_SoldList]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t.RefPaper ,
        t.RefPurchaseOrder ,
        t.SaveFrom ,
        t.QuotationID ,
        t.QuotationRef ,
        t.InvoiceTitle ,
        t.DateIs ,
        t.UserID ,
        t.UserIs ,
        t.SalespersonID ,
        t.Salesperson ,
        t.CommissionRate ,
        t.CommissionRateType ,
        t.CommissionRateOn ,
        t.StatusPayment ,
        t.CommissionValueF ,
        t.CommissionValueD ,
        t.SalespersonTakeCommission ,
        t.CommissionAvailableValueF ,
        t.CommissionAvailableValueD ,
        t.AccountCustomerID ,
        t.AccountCustomer ,
        t.AccountCustomerNumber ,
        t1.BalanceF ,
        t1.BalanceD ,
        t1.BalanceLL ,
        t1.BalanceEuro ,
        t.AccountBox ,
        t.AccountBoxNumber ,
        t.PaymentMethod ,
        t.Currency ,
        t.ExchangeRate ,
        t.ExchangeRateLL ,
        t.ExchangeRateEuro ,
        t.TaxExchangeRateLL ,
        t.TaxExchangeRateEuro ,
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
        t.FirstPaymentF ,
        t.FirstPaymentD ,
        t.Qtys ,
        t.DescriptionIs ,
        t.WFPFrom ,
        t.WFPReported ,
        t.FrameJobOrderID ,
        t.FrameJobOrderRefF ,
        t.ItemsNames ,
        t.DateCreate ,
        t.IsSync
FROM    Invoices.t_Sold AS t
INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountCustomerID;

















GO
