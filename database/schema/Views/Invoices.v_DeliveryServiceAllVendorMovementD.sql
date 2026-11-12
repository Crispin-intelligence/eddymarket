SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_DeliveryServiceAllVendorMovementD]
AS
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendorID ,
            t.CostD AS Cost ,
            t.RestD AS Rest ,
            t.AccountCustomer ,
            t.AccountCustomerNumber ,
            t.AccountCustomerIsVendor ,
            t.ToAddress ,
            t.DeliveryChargeD AS DeliveryCharge ,
            t.DeliveryChargeStatus
    FROM    Invoices.t_DeliveryService AS t
    UNION ALL
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendorID ,
            t.CostD AS Cost ,
            t.RestD AS Rest ,
            t.AccountCustomer ,
            t.AccountCustomerNumber ,
            t.AccountCustomerIsVendor ,
            t.ToAddress ,
            t.DeliveryChargeD AS DeliveryCharge ,
            t.DeliveryChargeStatus
    FROM    Invoices.t_DeliveryServiceHistory AS t;


		












GO
