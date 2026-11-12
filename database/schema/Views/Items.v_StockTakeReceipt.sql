SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_StockTakeReceipt]
AS
SELECT t.ID,
       t.RefF,
       t.DateIs,
       t.Warehouse,
       t.ReasonStockAdjustment,
       t.UserIs,
       t.NetIsF,
       t.DescriptionIs
FROM Items.t_StockTake AS t;



GO
