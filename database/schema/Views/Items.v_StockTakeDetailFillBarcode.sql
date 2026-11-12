SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_StockTakeDetailFillBarcode]
AS
SELECT t.ID,
       t.StockTakeID,
       t.ItemSharedID,
       t1.Name,
       t1.Barcode,
       t.Qty,
       t.Qtys,
       t1.SellWithTaxF,
       t1.QtyCurrent
FROM Items.t_StockTakeDetail AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID;




GO
