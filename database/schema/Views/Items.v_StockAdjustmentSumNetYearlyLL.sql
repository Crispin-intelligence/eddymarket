SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_StockAdjustmentSumNetYearlyLL]
AS
SELECT t.DateYearly AS DateOnly,
       t.ReasonStockAdjustment,
       t.UserIs,
       SUM(t.NetIsLL) AS NetIs,
       SUM(t.Qtys) AS Qtys
FROM Items.t_StockAdjustment AS t
GROUP BY t.DateYearly,
         t.ReasonStockAdjustment,
         t.UserIs;





GO
