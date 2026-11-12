SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [Invoices].[v_SoldDeletedList]
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
        t.DiscountIsF ,
        t.DiscountIsD ,
        t.TaxRate ,
        t.TaxValueF ,
        t.TaxValueD ,
        t.NetIsF ,
        t.NetIsD ,
        t.NetIsLL ,
        t.NetIsEuro ,
        t.ProfitF ,
        t.ProfitD ,
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
FROM    Invoices.t_SoldDeleted AS t;















GO
