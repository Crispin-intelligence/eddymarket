SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Invoices].[v_ProfitDailyLL]
AS
SELECT  t.ID ,
        t.DateIs ,
        t.SalesQtys ,
        t.SalesLL AS Sales ,
        t.GymSubscriptionLL AS GymSubscription ,
        t.CarRentalLL AS CarRental ,
        t.CostLL AS Cost ,
        t.SalesCommissionLL AS SalesCommission ,
        t.ProfitGrossLL AS ProfitGross ,
        t.ProfitGrossRate ,
        t.ProfitSalesRefundLL AS ProfitSalesRefund ,
        t.ExpensesLL AS Expenses ,
        t.SalaryLL AS Salary ,
        t.ProfitNetLL AS ProfitNet ,
        t.ProfitNetRate
FROM    Invoices.t_ProfitDaily AS t;








GO
