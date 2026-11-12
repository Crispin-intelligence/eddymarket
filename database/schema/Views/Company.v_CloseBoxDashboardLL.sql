SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_CloseBoxDashboardLL]
AS
SELECT t.DateOnly,
       t.FromUser,
       t.BalanceLL AS Balance
FROM Company.t_CloseBox AS t;



GO
