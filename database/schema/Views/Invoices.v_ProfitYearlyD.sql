SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Invoices].[v_ProfitYearlyD]
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
                  t.DateYearly AS DateIs ,
                  SUM(t.SalesQtys) AS SalesQtys ,
                  SUM(t.SalesD) AS Sales ,
                  SUM(t.GymSubscriptionD) AS GymSubscription ,
                  SUM(t.CarRentalD) AS CarRental ,
                  SUM(t.CostD) AS Cost ,
                  SUM(t.SalesCommissionD) AS SalesCommission ,
                  SUM(t.ProfitGrossD) AS ProfitGross ,
                  SUM(t.ProfitSalesRefundD) AS ProfitSalesRefund ,
                  SUM(t.ExpensesD) AS Expenses ,
                  SUM(t.SalaryD) AS Salary ,
                  SUM(t.ProfitNetD) AS ProfitNet
          FROM    Invoices.t_ProfitDaily AS t
          GROUP BY t.DateYearly
        ) AS o;










GO
