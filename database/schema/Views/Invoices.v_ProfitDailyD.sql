SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Invoices].[v_ProfitDailyD]
AS
SELECT  t.ID ,
        t.DateIs ,
        t.SalesQtys ,
        t.SalesD AS Sales ,
        t.GymSubscriptionD AS GymSubscription ,
        t.CarRentalD AS CarRental ,
        t.CostD AS Cost ,
        t.SalesCommissionD AS SalesCommission ,
        t.ProfitGrossD AS ProfitGross ,
        t.ProfitGrossRate ,
        t.ProfitSalesRefundD AS ProfitSalesRefund ,
        t.ExpensesD AS Expenses ,
        t.SalaryD AS Salary ,
        t.ProfitNetD AS ProfitNet ,
        t.ProfitNetRate
FROM    Invoices.t_ProfitDaily AS t;








GO
