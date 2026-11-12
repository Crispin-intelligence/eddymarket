SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_OpenBoxDashboardD]
AS
SELECT t.DateOnly,
       t.ToAccount,
       t.BalanceD AS Balance
FROM Company.t_OpenBox AS t;




GO
