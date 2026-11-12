SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_CloseBoxDashboardEuro]
AS
SELECT t.DateOnly,
       t.FromUser,
       t.BalanceEuro AS Balance
FROM Company.t_CloseBox AS t;



GO
