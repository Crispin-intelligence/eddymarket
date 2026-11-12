SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_PaySalaryBalanceSumMonthlyLast6MonthsLL]
AS
SELECT t.DateMonthly,
       SUM(t1.BalanceLL) AS Balance
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateMonthly
    FROM Company.t_PaySalary AS s
    ORDER BY s.DateMonthly DESC
) AS t
    LEFT JOIN Company.t_PaySalary AS t1
        ON t1.DateMonthly = t.DateMonthly
GROUP BY t.DateMonthly;




GO
