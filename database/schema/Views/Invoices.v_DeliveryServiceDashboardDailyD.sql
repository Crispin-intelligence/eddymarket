SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_DeliveryServiceDashboardDailyD]
AS
    SELECT  t.DateOnly ,
            t.AccountVendor ,
            t.TypeIsAR ,
            t.TypeIsEN ,
            t.StatusIsAR ,
            t.StatusIsEN ,
            t.CostD AS Cost ,
            t.PaymentD AS Payment ,
            t.RestD AS Rest ,
            t.AccountCustomer ,
            t.DeliveryChargeD AS DeliveryCharge ,
            t.DeliveryChargeStatusAR ,
            t.DeliveryChargeStatusEN ,
            t.AccountEmployee ,
            t.ExpenseD AS Expense ,
            t.ExpenseStatusAR,
            t.ExpenseStatusEN
    FROM    Invoices.t_DeliveryService AS t
    UNION ALL
    SELECT  t.DateOnly ,
            t.AccountVendor ,
            t.TypeIsAR ,
            t.TypeIsEN ,
            t.StatusIsAR ,
            t.StatusIsEN ,
            t.CostD AS Cost ,
            t.PaymentD AS Payment ,
            t.RestD AS Rest ,
            t.AccountCustomer ,
            t.DeliveryChargeD AS DeliveryCharge ,
            t.DeliveryChargeStatusAR ,
            t.DeliveryChargeStatusEN ,
            t.AccountEmployee ,
            t.ExpenseD AS Expense ,
            t.ExpenseStatusAR,
            t.ExpenseStatusEN
    FROM    Invoices.t_DeliveryServiceHistory AS t;
		





GO
