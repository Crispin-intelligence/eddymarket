SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Invoices].[v_ProfitDailyEuro]
AS
SELECT  t.ID ,
        t.DateIs ,
        t.SalesQtys ,
        t.SalesEuro AS Sales ,
        t.GymSubscriptionEuro AS GymSubscription ,
        t.CarRentalEuro AS CarRental ,
        t.CostEuro AS Cost ,
        t.SalesCommissionEuro AS SalesCommission ,
        t.ProfitGrossEuro AS ProfitGross ,
        t.ProfitGrossRate ,
        t.ProfitSalesRefundEuro AS ProfitSalesRefund ,
        t.ExpensesEuro AS Expenses ,
        t.SalaryEuro AS Salary ,
        t.ProfitNetEuro AS ProfitNet ,
        t.ProfitNetRate
FROM    Invoices.t_ProfitDaily AS t;








GO
