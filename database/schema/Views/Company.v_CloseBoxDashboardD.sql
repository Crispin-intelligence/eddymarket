SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_CloseBoxDashboardD]
AS
SELECT t.DateOnly,
       t.FromUser,
       t.BalanceD AS Balance
FROM Company.t_CloseBox AS t;


GO
