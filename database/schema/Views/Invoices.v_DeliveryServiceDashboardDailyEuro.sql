SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Invoices].[v_DeliveryServiceDashboardDailyEuro]
AS
    SELECT  t.DateOnly ,
            t.AccountVendor ,
            t.TypeIsAR ,
            t.TypeIsEN ,
            t.StatusIsAR ,
            t.StatusIsEN ,
            t.CostEuro AS Cost ,
            t.PaymentEuro AS Payment ,
            t.RestEuro AS Rest ,
            t.AccountCustomer ,
            t.DeliveryChargeEuro AS DeliveryCharge ,
            t.DeliveryChargeStatusAR ,
            t.DeliveryChargeStatusEN ,
            t.AccountEmployee ,
            t.ExpenseEuro AS Expense ,
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
            t.CostEuro AS Cost ,
            t.PaymentEuro AS Payment ,
            t.RestEuro AS Rest ,
            t.AccountCustomer ,
            t.DeliveryChargeEuro AS DeliveryCharge ,
            t.DeliveryChargeStatusAR ,
            t.DeliveryChargeStatusEN ,
            t.AccountEmployee ,
            t.ExpenseEuro AS Expense ,
            t.ExpenseStatusAR,
            t.ExpenseStatusEN
    FROM    Invoices.t_DeliveryServiceHistory AS t;







GO
