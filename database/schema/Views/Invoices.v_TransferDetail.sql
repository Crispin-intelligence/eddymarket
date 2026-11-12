SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_TransferDetail]
AS
SELECT t.ID,
       t.TransferID,
       t.ItemSharedID,
       t.ItemUnityID,
       t.Qty,
       t.QtyWithUnity,
       t.Qtys,
       t.Price,
       t.PriceF,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       t.DiscountIs,
       t.DiscountIsF,
       t.DiscountIsValue,
       t.DiscountIsValueF,
       t.DiscountIsValueD,
       t.DiscountIsValueLL,
       t.DiscountIsValueEuro,
       t.SubTotal,
       t.SubTotalF,
       t.SubTotalD,
       t.SubTotalLL,
       t.SubTotalEuro,
       t.TaxRate,
       t.TaxRateF,
       t.TaxValue,
       t.TaxValueF,
       t.TaxValueD,
       t.TaxValueLL,
       t.TaxValueEuro,
       t.Total,
       t.TotalF,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate
FROM Invoices.t_TransferDetail AS t;

GO
