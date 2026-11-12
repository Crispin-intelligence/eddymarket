SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_StockAdjustmentDetailSerial]
AS
SELECT t.ID,
       t.StockAdjustmentID,
       t.StockAdjustmentDetailID,
       t.SerialID,
       t.DateCreate
FROM Items.t_StockAdjustmentDetailSerial AS t;




GO
