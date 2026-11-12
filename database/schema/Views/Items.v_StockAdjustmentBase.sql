SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_StockAdjustmentBase]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateCreate
FROM Items.t_StockAdjustment AS t;




GO
