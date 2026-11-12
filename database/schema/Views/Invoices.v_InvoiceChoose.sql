SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_InvoiceChoose]
AS
SELECT 2 AS SectionID ,
    t.ID ,
    t.Ref ,
    t.RefF ,
    t.RefPaper ,
    t.InvoiceTitle ,
    t.DateOnly ,
    t.Salesperson ,
    t.StatusPayment ,
    t.AccountCustomerID AS AccountID ,
    t.AccountCustomer AS Account ,
    t.AccountCustomerNumber AS AccountNumber ,
    t.PaymentMethod ,
    t.ExchangeRate ,
    t.ExchangeRateLL ,
    t.ExchangeRateEuro ,
    t.TaxExchangeRateLL ,
    t.TaxExchangeRateEuro ,
    t.NetIs ,
    t.NetIsF ,
    t.FirstPayment ,
    t.FirstPaymentF ,
    t.DescriptionIs ,
    t.ItemsNames
  FROM Invoices.t_Sold AS t
UNION ALL
SELECT 0 AS SectionID ,
    t.ID ,
    t.Ref ,
    t.RefF ,
    t.RefPaper ,
    t.InvoiceTitle ,
    t.DateOnly ,
    N'' AS Salesperson ,
    CONVERT(TINYINT, 0) AS StatusPayment ,
    t.AccountVendorID AS AccountID ,
    t.AccountVendor AS Account ,
    t.AccountVendorNumber AS AccountNumber ,
    t.PaymentMethod ,
    t.ExchangeRate ,
    t.ExchangeRateLL ,
    t.ExchangeRateEuro ,
    t.TaxExchangeRateLL ,
    t.TaxExchangeRateEuro ,
    t.NetIs ,
    t.NetIsF ,
    t.FirstPayment ,
    t.FirstPaymentF ,
    t.DescriptionIs ,
    t.ItemsNames
  FROM Invoices.t_Purchasing AS t;
   


GO
