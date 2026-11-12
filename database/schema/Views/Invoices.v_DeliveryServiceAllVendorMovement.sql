SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_DeliveryServiceAllVendorMovement]
AS
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendorID ,
            t.CostD ,
            t.CostLL ,
            t.CostEuro ,
            t.RestD ,
            t.RestLL ,
            t.RestEuro ,
            t.AccountCustomer ,
            t.AccountCustomerNumber ,
            t.AccountCustomerIsVendor ,
            t.ToAddress ,
            t.DeliveryChargeD ,
            t.DeliveryChargeLL ,
            t.DeliveryChargeEuro,
			t.DeliveryChargeStatus
    FROM    Invoices.t_DeliveryService AS t
    UNION ALL
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendorID ,
            t.CostD ,
            t.CostLL ,
            t.CostEuro ,
            t.RestD ,
            t.RestLL ,
            t.RestEuro ,
            t.AccountCustomer ,
            t.AccountCustomerNumber ,
            t.AccountCustomerIsVendor ,
            t.ToAddress ,
            t.DeliveryChargeD ,
            t.DeliveryChargeLL ,
            t.DeliveryChargeEuro,
			t.DeliveryChargeStatus
    FROM    Invoices.t_DeliveryServiceHistory AS t;


		












GO
