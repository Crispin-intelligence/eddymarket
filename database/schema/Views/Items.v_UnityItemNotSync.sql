SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_UnityItemNotSync]
AS
SELECT  t.ID ,
        t.UnityID ,
        t.Unity ,
        t.SharedID ,
        t.Qty ,
        t.QtyCurrent ,
        t.PrimaryIs ,
        t.Purchasing ,
        t.Sold ,
        t.Inventory ,
        t.UseInTransfer ,
        t.BarCode ,
        t.CurrencyID ,
        t.Currency ,
        t.Price ,
        t.PriceF ,
        t.PriceD ,
        t.PriceLL ,
        t.PriceEuro ,
        t.PriceWithTax ,
        t.PriceWithTaxF ,
        t.PriceWithTaxD ,
        t.PriceWithTaxLL ,
        t.PriceWithTaxEuro ,
        t.LowestPrice ,
        t.LowestPriceF ,
        t.LowestPriceD ,
        t.CurrencyIDCost ,
        t.CurrencyCost ,
        t.Cost ,
        t.CostF ,
        t.CostD ,
        t.CostLL ,
        t.CostEuro ,
        t.CostWithTax ,
        t.CostWithTaxF ,
        t.CostWithTaxD ,
        t.CostWithTaxLL ,
        t.CostWithTaxEuro ,
        t.SearchText ,
        t.DateCreate
FROM    Items.t_UnityItem AS t
WHERE   t.IsSync = 0;


GO
