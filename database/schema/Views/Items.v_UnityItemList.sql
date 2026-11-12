SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_UnityItemList]
AS
SELECT t.ID,
       t.UnityID,
       t.Unity,
       t.SharedID,
       t1.Name,
       t1.Barcodes,
       t.Qty,
       t.QtyCurrent,
       t.PrimaryIs,
       t.Purchasing,
       t.Sold,
       t.Inventory,
       t.UseInTransfer,
       t.BarCode,
       t.Currency,
       t.PriceF,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       t.PriceWithTaxF,
       t.PriceWithTaxD,
       t.PriceWithTaxLL,
       t.PriceWithTaxEuro,
       t.LowestPriceF,
       t.LowestPriceD,
       t.Cost,
       t.CostF,
       t.CostD,
       t.CostLL,
       t.CostEuro,
       t.CostWithTax,
       t.CostWithTaxF,
       t.CostWithTaxD,
       t.CostWithTaxLL,
       t.CostWithTaxEuro,
       t.DateCreate
FROM Items.t_UnityItem AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.SharedID;








GO
