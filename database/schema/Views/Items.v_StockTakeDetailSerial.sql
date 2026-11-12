SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_StockTakeDetailSerial]
AS
SELECT t.ID,
       t.StockTakeID,
       t.StockTakeDetailID,
       t.SerialID,
       t.DateCreate
FROM Items.t_StockTakeDetailSerial AS t;





GO
