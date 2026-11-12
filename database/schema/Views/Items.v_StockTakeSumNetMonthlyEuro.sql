SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Items].[v_StockTakeSumNetMonthlyEuro]
AS
SELECT t.DateMonthly AS DateOnly,
       t.ReasonStockAdjustment,
       t.UserIs,
       SUM(t.NetIsEuro) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Items.t_StockTake AS t
GROUP BY t.DateMonthly,
         t.ReasonStockAdjustment,
         t.UserIs;






GO
