SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Company].[v_ChequeDashBoardLast3MonthLLEN]
AS
SELECT SUM(t.AmountLL) AS Amount,
       t.DateDueMonthly,
       t.TypeIsEN AS TypeIs
FROM Company.t_Cheque AS t
    INNER JOIN
    (
        SELECT DISTINCT TOP (3)
               s.DateDueMonthly
        FROM Company.t_Cheque AS s
        ORDER BY s.DateDueMonthly DESC
    ) AS t1
        ON t1.DateDueMonthly = t.DateDueMonthly
GROUP BY t.DateDueMonthly,
         t.TypeIsEN;





GO
