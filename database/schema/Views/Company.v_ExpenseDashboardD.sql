SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_ExpenseDashboardD]
AS
SELECT t.DateOnly,
       t.ToAccount,
       t.NetIsD AS Balance
FROM Company.t_Expense AS t;




GO
