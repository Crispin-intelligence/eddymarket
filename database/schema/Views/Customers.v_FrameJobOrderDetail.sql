SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Customers].[v_FrameJobOrderDetail]
AS

SELECT  t.ID ,
        t.FrameJobOrderID ,
        t.ItemSharedID ,
        t.ItemID ,
        t.ItemUnityID ,
        t.Qty ,
        t.QtyWithUnity ,
        t.Qtys ,
        t.ItemType ,
        t.Sale ,
        t.SaleF ,
        t.SaleD ,
        t.SaleLL ,
        t.SaleEuro ,
        t.DiscountIs ,
        t.DiscountIsF ,
        t.DiscountIsValue ,
        t.DiscountIsValueF ,
        t.DiscountIsValueD ,
        t.DiscountIsValueLL ,
        t.DiscountIsValueEuro ,
        t.SubTotal ,
        t.SubTotalF ,
        t.SubTotalD ,
        t.SubTotalLL ,
        t.SubTotalEuro ,
        t.DiscountOrder ,
        t.DiscountOrderF ,
        t.DiscountOrderD ,
        t.DiscountOrderLL ,
        t.DiscountOrderEuro ,
        t.TaxRate ,
        t.TaxRateF ,
        t.TaxValue ,
        t.TaxValueF ,
        t.TaxValueD ,
        t.TaxValueLL ,
        t.TaxValueEuro ,
        t.Total ,
        t.TotalF ,
        t.TotalD ,
        t.TotalLL ,
        t.TotalEuro ,
        t.Cost ,
        t.CostF ,
        t.CostD ,
        t.CostLL ,
        t.CostEuro ,
        t.TotalCost ,
        t.TotalCostF ,
        t.TotalCostD ,
        t.TotalCostLL ,
        t.TotalCostEuro ,
        t.Profit ,
        t.ProfitF ,
        t.ProfitD ,
        t.ProfitLL ,
        t.ProfitEuro ,
        t.ProfitTotal ,
        t.ProfitTotalF ,
        t.ProfitTotalD ,
        t.ProfitTotalLL ,
        t.ProfitTotalEuro ,
        t.DescriptionIs ,
        t.SortAt ,
        t.DateCreate ,
        t.IsSync
FROM    Customers.t_FrameJobOrderDetail AS t;





GO
