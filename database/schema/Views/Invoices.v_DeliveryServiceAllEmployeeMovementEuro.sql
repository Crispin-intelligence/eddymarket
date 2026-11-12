SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_DeliveryServiceAllEmployeeMovementEuro]
AS
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendor ,
            t.CostEuro AS Cost ,
            t.AccountCustomer ,
            t.ToAddress ,
            t.AccountEmployeeID ,
            t.DeliveryChargeEuro AS DeliveryCharge ,
            t.ExpenseEuro AS Expense ,
            t.ExpenseStatus
    FROM    Invoices.t_DeliveryService AS t
    UNION ALL
    SELECT  t.ID ,
            t.RefF + '\' + t.RefPaper AS RefMix ,
            t.DateOnly ,
            t.AccountVendor ,
            t.CostEuro AS Cost ,
            t.AccountCustomer ,
            t.ToAddress ,
            t.AccountEmployeeID ,
            t.DeliveryChargeEuro AS DeliveryCharge ,
            t.ExpenseEuro AS Expense ,
            t.ExpenseStatus
    FROM    Invoices.t_DeliveryServiceHistory AS t;


		












GO
