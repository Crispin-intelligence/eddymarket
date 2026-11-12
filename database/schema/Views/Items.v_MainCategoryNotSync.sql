SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Items].[v_MainCategoryNotSync]
AS
SELECT  t.ID ,
        t.Name ,
        t.DescriptionIs ,
        t.ImageIs ,
        t.ImagePath ,
        t.Printer ,
        t.SubCategoryC ,
        t.ItemC ,
        t.ItemInListCount ,
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
        t.OrderBy ,
        t.SearchText ,
        t.DateCreate
FROM    Items.t_MainCategory AS t
WHERE   t.IsSync = 0;





GO
