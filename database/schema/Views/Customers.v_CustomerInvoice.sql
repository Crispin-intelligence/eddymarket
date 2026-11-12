SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Customers].[v_CustomerInvoice]
AS
SELECT t.ID,
       t.Name,
       t.SalesPersonID,
	   t.PricingType,
       t.PriceIncreaseRate,
       t.PaymentMethod,
       t.MaximumDebtInvoiceCurrencyID,
       t.MaximumDebtInvoice,
	   t.FromWFP
FROM Customers.t_Customer AS t;



GO
