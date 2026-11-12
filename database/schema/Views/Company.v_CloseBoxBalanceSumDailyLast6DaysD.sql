SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_CloseBoxBalanceSumDailyLast6DaysD]
AS
SELECT t.DateOnly,
       SUM(t1.BalanceD) AS Balance
FROM
(
    SELECT DISTINCT TOP (6)
           s.DateOnly
    FROM Company.t_CloseBox AS s
    ORDER BY s.DateOnly DESC
) AS t
    LEFT JOIN Company.t_CloseBox AS t1
        ON t1.DateOnly = t.DateOnly
GROUP BY t.DateOnly;


GO
