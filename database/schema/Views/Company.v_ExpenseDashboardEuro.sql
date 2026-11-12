SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Company].[v_ExpenseDashboardEuro]
AS
SELECT t.DateOnly,
       t.ToAccount,
       t.NetIsEuro AS Balance
FROM Company.t_Expense AS t;





GO
