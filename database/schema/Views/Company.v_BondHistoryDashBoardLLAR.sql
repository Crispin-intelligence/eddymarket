SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_BondHistoryDashBoardLLAR]
AS
SELECT SUM(t.AmountLL) AS Amount,
       t.DateDueMonthly,
       t1.Name AS FromAccount,
       t.IsPaid,
       t.TypeIsAR AS TypeIs
FROM Company.t_BondHistory AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.ToAccountID
GROUP BY t.DateDueMonthly,
         t1.Name,
         t.IsPaid,
         t.TypeIsAR;








GO
