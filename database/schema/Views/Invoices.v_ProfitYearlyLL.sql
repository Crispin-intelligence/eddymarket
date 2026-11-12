SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Invoices].[v_ProfitYearlyLL]
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
                  SUM(t.SalesLL) AS Sales ,
                  SUM(t.GymSubscriptionLL) AS GymSubscription ,
                  SUM(t.CarRentalLL) AS CarRental ,
                  SUM(t.CostLL) AS Cost ,
                  SUM(t.SalesCommissionLL) AS SalesCommission ,
                  SUM(t.ProfitGrossLL) AS ProfitGross ,
                  SUM(t.ProfitSalesRefundLL) AS ProfitSalesRefund ,
                  SUM(t.ExpensesLL) AS Expenses ,
                  SUM(t.SalaryLL) AS Salary ,
                  SUM(t.ProfitNetLL) AS ProfitNet
          FROM    Invoices.t_ProfitDaily AS t
          GROUP BY t.DateYearly
        ) AS o;










GO
