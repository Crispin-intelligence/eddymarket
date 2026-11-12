SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_ExpenseDashboardLL]
AS
SELECT t.DateOnly,
       t.ToAccount,
       t.NetIsLL AS Balance
FROM Company.t_Expense AS t;





GO
