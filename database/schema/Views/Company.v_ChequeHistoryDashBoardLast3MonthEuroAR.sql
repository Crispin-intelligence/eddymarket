SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_ChequeHistoryDashBoardLast3MonthEuroAR]
AS
SELECT SUM(t.AmountEuro) AS Amount,
       t.DateDueMonthly,
       t.TypeIsAR AS TypeIs
FROM Company.t_ChequeHistory AS t
    INNER JOIN
    (
        SELECT DISTINCT TOP (3)
               s.DateDueMonthly
        FROM Company.t_ChequeHistory AS s
        ORDER BY s.DateDueMonthly DESC
    ) AS t1
        ON t1.DateDueMonthly = t.DateDueMonthly
GROUP BY t.DateDueMonthly,
         t.TypeIsAR;





GO
