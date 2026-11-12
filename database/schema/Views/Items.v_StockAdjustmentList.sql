SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_StockAdjustmentList]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateIs,
	   t.ReasonStockAdjustment,
       t.UserID,
       t.UserIs,
       t.Currency,
       t.ExchangeRate,
       t.NetIsF,
       t.NetIsD,
       t.NetIsLL,
       t.NetIsEuro,
       t.Qtys,
       t.DescriptionIs,
       t.ItemsNames,
       t.DateCreate
FROM Items.t_StockAdjustment AS t;









GO
