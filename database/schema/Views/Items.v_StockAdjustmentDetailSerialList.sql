SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_StockAdjustmentDetailSerialList]
AS
SELECT t.ID,
       t.StockAdjustmentID,
       t.StockAdjustmentDetailID,
       t.SerialID,
       t1.SerialText,
       t.DateCreate
FROM Items.t_StockAdjustmentDetailSerial AS t
    LEFT JOIN Items.t_ItemSerial AS t1
        ON t1.ID = t.SerialID;






GO
