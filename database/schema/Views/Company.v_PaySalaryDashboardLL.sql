SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_PaySalaryDashboardLL]
AS
SELECT t.DateOnly,
       t.ToAccount,
       t.BalanceLL AS Balance
FROM Company.t_PaySalary AS t;





GO
