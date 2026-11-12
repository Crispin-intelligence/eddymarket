SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_DeliveryServiceAllEmployeeMovement]
AS
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendor ,
            t.CostD ,
            t.CostLL ,
            t.CostEuro ,
            t.AccountCustomer ,
            t.ToAddress ,
            t.AccountEmployeeID ,
            t.DeliveryChargeD ,
            t.DeliveryChargeLL ,
            t.DeliveryChargeEuro ,
            t.ExpenseD ,
            t.ExpenseLL ,
            t.ExpenseEuro ,
            t.ExpenseStatus
    FROM    Invoices.t_DeliveryService AS t
    UNION ALL
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendor ,
            t.CostD ,
            t.CostLL ,
            t.CostEuro ,
            t.AccountCustomer ,
            t.ToAddress ,
            t.AccountEmployeeID ,
            t.DeliveryChargeD ,
            t.DeliveryChargeLL ,
            t.DeliveryChargeEuro ,
            t.ExpenseD ,
            t.ExpenseLL ,
            t.ExpenseEuro ,
            t.ExpenseStatus
    FROM    Invoices.t_DeliveryServiceHistory AS t;


		












GO
