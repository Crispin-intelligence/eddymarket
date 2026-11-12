SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_DeliveryServiceAllVendorMovementLL]
AS
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendorID ,
            t.CostLL AS Cost ,
            t.RestLL AS Rest ,
            t.AccountCustomer ,
            t.AccountCustomerNumber ,
            t.AccountCustomerIsVendor ,
            t.ToAddress ,
            t.DeliveryChargeLL AS DeliveryCharge ,
            t.DeliveryChargeStatus
    FROM    Invoices.t_DeliveryService AS t
    UNION ALL
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendorID ,
            t.CostLL AS Cost ,
            t.RestLL AS Rest ,
            t.AccountCustomer ,
            t.AccountCustomerNumber ,
            t.AccountCustomerIsVendor ,
            t.ToAddress ,
            t.DeliveryChargeLL AS DeliveryCharge ,
            t.DeliveryChargeStatus
    FROM    Invoices.t_DeliveryServiceHistory AS t;


		












GO
