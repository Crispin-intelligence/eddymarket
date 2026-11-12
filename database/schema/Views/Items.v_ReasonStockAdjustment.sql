SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ReasonStockAdjustment]
AS
SELECT t.ID,
       t.Name,
       t.DescriptionIs,
       t.DateCreate
FROM Items.t_ReasonStockAdjustment AS t;




GO
