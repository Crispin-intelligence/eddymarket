SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Invoices].[v_DeliveryServiceHistory]
AS
    SELECT  t.ID ,
            t.Ref ,
            t.RefF ,
            t.RefPaper ,
            t.DateIs ,
            t.DateOnly ,
            t.TimeOnly ,
            t.DateMonthly ,
            t.DateYearly ,
            t.TypeIs ,
            t.TypeIsAR ,
            t.TypeIsEN ,
            t.StatusIs ,
            t.StatusIsAR ,
            t.StatusIsEN ,
            t.DescriptionIs ,
            t.UserID ,
            t.UserIs ,
            t.AccountVendorID ,
            t.AccountVendor ,
            t.AccountVendorNumber ,
            t.FromAddress ,
            t.ItemsNames ,
            t.CostCurrencyID ,
            t.CostCurrency ,
            t.CostExchangeRate ,
            t.CostExchangeRateLL ,
            t.CostExchangeRateEuro ,
            t.Cost ,
            t.CostF ,
            t.CostD ,
            t.CostLL ,
            t.CostEuro ,
            t.Payment ,
            t.PaymentF ,
            t.PaymentD ,
            t.PaymentLL ,
            t.PaymentEuro ,
            t.Rest ,
            t.RestF ,
            t.RestD ,
            t.RestLL ,
            t.RestEuro ,
            t.AccountCustomerID ,
            t.AccountCustomer ,
            t.AccountCustomerNumber ,
            t.AccountCustomerIsVendor ,
            t.ToAddress ,
            t.DeliveryDate ,
            t.DeliveryChargeCurrencyID ,
            t.DeliveryChargeCurrency ,
            t.DeliveryChargeExchangeRate ,
            t.DeliveryChargeExchangeRateLL ,
            t.DeliveryChargeExchangeRateEuro ,
            t.DeliveryCharge ,
            t.DeliveryChargeF ,
            t.DeliveryChargeD ,
            t.DeliveryChargeLL ,
            t.DeliveryChargeEuro ,
			t.DeliveryChargeStatus,
			t.DeliveryChargeStatusAR,
			t.DeliveryChargeStatusEN,
            t.AccountEmployeeID ,
            t.AccountEmployee ,
            t.AccountEmployeeNumber ,
            t.AssignDate ,
            t.Expense ,
            t.ExpenseF ,
            t.ExpenseD ,
            t.ExpenseLL ,
            t.ExpenseEuro ,
            t.ExpenseStatus ,
            t.ExpenseStatusAR ,
            t.ExpenseStatusEN ,
            t.ExpensePaymentDate ,
			t.ProcessIn,
            t.DateCreate
    FROM    Invoices.t_DeliveryServiceHistory AS t;
		








GO
