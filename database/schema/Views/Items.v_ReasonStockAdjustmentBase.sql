SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ReasonStockAdjustmentBase]
AS
SELECT t.ID,
       t.Name
FROM Items.t_ReasonStockAdjustment AS t;



GO
