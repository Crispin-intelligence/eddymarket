SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_BrandNotSync]
AS
SELECT t.ID ,
    t.Name ,
    t.DescriptionIs ,
    t.ItemC ,
    t.PurchaseC ,
    t.PurchaseQty ,
    t.PurchaseReturnC ,
    t.PurchaseReturnQty ,
    t.SellC ,
    t.SellQty ,
    t.SellReturnC ,
    t.SellReturnQty ,
    t.QuotationC ,
    t.QuotationQty ,
    t.SearchText ,
    t.DateCreate
  FROM Items.t_Brand AS t
  WHERE t.IsSync = 0;






GO
