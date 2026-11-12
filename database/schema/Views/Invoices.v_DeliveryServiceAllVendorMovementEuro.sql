SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_DeliveryServiceAllVendorMovementEuro]
AS
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendorID ,
            t.CostEuro AS Cost ,
            t.RestEuro AS Rest ,
            t.AccountCustomer ,
            t.AccountCustomerNumber ,
            t.AccountCustomerIsVendor ,
            t.ToAddress ,
            t.DeliveryChargeEuro AS DeliveryCharge ,
            t.DeliveryChargeStatus
    FROM    Invoices.t_DeliveryService AS t
    UNION ALL
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendorID ,
            t.CostEuro AS Cost ,
            t.RestEuro AS Rest ,
            t.AccountCustomer ,
            t.AccountCustomerNumber ,
            t.AccountCustomerIsVendor ,
            t.ToAddress ,
            t.DeliveryChargeEuro AS DeliveryCharge ,
            t.DeliveryChargeStatus
    FROM    Invoices.t_DeliveryServiceHistory AS t;


		












GO
