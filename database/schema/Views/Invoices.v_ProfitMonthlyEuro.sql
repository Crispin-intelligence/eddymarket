SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Invoices].[v_ProfitMonthlyEuro]
AS
SELECT  o.ID ,
        o.DateIs ,
        o.SalesQtys ,
        o.Sales ,
        o.GymSubscription ,
        o.CarRental ,
        o.Cost ,
        o.SalesCommission ,
        o.ProfitGross ,
        CASE o.Sales + o.GymSubscription + o.CarRental
          WHEN 0 THEN 0
          ELSE ( o.ProfitGross / ( o.Sales + o.GymSubscription + o.CarRental ) ) * 100.0
        END AS ProfitGrossRate ,
        o.ProfitSalesRefund ,
        o.Expenses ,
        o.Salary ,
        o.ProfitNet ,
        CASE o.Sales
          WHEN 0 THEN 0
          ELSE ( o.ProfitNet / ( o.Sales + o.GymSubscription + o.CarRental ) ) * 100.0
        END AS ProfitNetRate
FROM    ( SELECT  MIN(t.ID) AS ID ,
                  t.DateMonthly AS DateIs ,
                  SUM(t.SalesQtys) AS SalesQtys ,
                  SUM(t.SalesEuro) AS Sales ,
                  SUM(t.GymSubscriptionEuro) AS GymSubscription ,
                  SUM(t.CarRentalEuro) AS CarRental ,
                  SUM(t.CostEuro) AS Cost ,
                  SUM(t.SalesCommissionEuro) AS SalesCommission ,
                  SUM(t.ProfitGrossEuro) AS ProfitGross ,
                  SUM(t.ProfitSalesRefundEuro) AS ProfitSalesRefund ,
                  SUM(t.ExpensesEuro) AS Expenses ,
                  SUM(t.SalaryEuro) AS Salary ,
                  SUM(t.ProfitNetEuro) AS ProfitNet
          FROM    Invoices.t_ProfitDaily AS t
          GROUP BY t.DateMonthly
        ) AS o;









GO
