SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_StockAdjustment]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateIs,
       t.DateOnly,
       t.DateMonthly,
       t.DateYearly,
       t.ReasonStockAdjustmentID,
       t.ReasonStockAdjustment,
       t.UserID,
       t.UserIs,
       t.CurrencyID,
       t.Currency,
       t.ExchangeRate,
       t.NetIs,
       t.NetIsF,
       t.NetIsD,
       t.NetIsLL,
       t.NetIsEuro,
       t.NetIsAR,
       t.NetIsEN,
       t.Qtys,
       t.DescriptionIs,
       t.ItemsNames,
       t.DateCreate
FROM Items.t_StockAdjustment AS t;









GO
