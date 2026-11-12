SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_PaySalaryDashboardEuro]
AS
SELECT t.DateOnly,
       t.ToAccount,
       t.BalanceEuro AS Balance
FROM Company.t_PaySalary AS t;





GO
