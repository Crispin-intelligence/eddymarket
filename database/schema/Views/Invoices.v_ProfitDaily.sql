SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_ProfitDaily]
AS
SELECT  t.ID ,
        t.DateIs ,
        t.DateMonthly ,
        t.DateYearly ,
        t.SalesQtys ,
        t.SalesD ,
        t.SalesLL ,
        t.SalesEuro ,
        t.GymSubscriptionD ,
        t.GymSubscriptionLL ,
        t.GymSubscriptionEuro ,
        t.CarRentalD ,
        t.CarRentalLL ,
        t.CarRentalEuro ,
        t.CostD ,
        t.CostLL ,
        t.CostEuro ,
        t.SalesCommissionD ,
        t.SalesCommissionLL ,
        t.SalesCommissionEuro ,
        t.ProfitGrossD ,
        t.ProfitGrossLL ,
        t.ProfitGrossEuro ,
        t.ProfitGrossRate ,
        t.ProfitSalesRefundD ,
        t.ProfitSalesRefundLL ,
        t.ProfitSalesRefundEuro ,
        t.ExpensesD ,
        t.ExpensesLL ,
        t.ExpensesEuro ,
        t.SalaryD ,
        t.SalaryLL ,
        t.SalaryEuro ,
        t.ProfitNetD ,
        t.ProfitNetLL ,
        t.ProfitNetEuro ,
        t.ProfitNetRate
FROM    Invoices.t_ProfitDaily AS t;









GO
