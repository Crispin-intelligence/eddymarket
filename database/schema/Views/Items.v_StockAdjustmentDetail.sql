SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_StockAdjustmentDetail]
AS
SELECT t.ID,
       t.StockAdjustmentID,
       t.ItemSharedID,
       t.ItemID,
       t.ItemUnityID,
       t.Qty,
       t.QtyWithUnity,
       t.Qtys,
       t.Price,
       t.PriceF,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       t.Total,
       t.TotalF,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate
FROM Items.t_StockAdjustmentDetail AS t;



GO
