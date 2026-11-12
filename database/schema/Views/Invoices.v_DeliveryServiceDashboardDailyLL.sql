SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Invoices].[v_DeliveryServiceDashboardDailyLL]
AS
    SELECT  t.DateOnly ,
            t.AccountVendor ,
            t.TypeIsAR ,
            t.TypeIsEN ,
            t.StatusIsAR ,
            t.StatusIsEN ,
            t.CostLL AS Cost ,
            t.PaymentLL AS Payment ,
            t.RestLL AS Rest ,
            t.AccountCustomer ,
            t.DeliveryChargeLL AS DeliveryCharge ,
            t.DeliveryChargeStatusAR ,
            t.DeliveryChargeStatusEN ,
            t.AccountEmployee ,
            t.ExpenseLL AS Expense ,
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
            t.CostLL AS Cost ,
            t.PaymentLL AS Payment ,
            t.RestLL AS Rest ,
            t.AccountCustomer ,
            t.DeliveryChargeLL AS DeliveryCharge ,
            t.DeliveryChargeStatusAR ,
            t.DeliveryChargeStatusEN ,
            t.AccountEmployee ,
            t.ExpenseLL AS Expense ,
            t.ExpenseStatusAR,
            t.ExpenseStatusEN
    FROM    Invoices.t_DeliveryServiceHistory AS t;







GO
