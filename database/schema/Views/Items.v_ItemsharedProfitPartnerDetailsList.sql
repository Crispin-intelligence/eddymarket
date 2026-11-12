SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemsharedProfitPartnerDetailsList]
AS
SELECT  t.ID ,
        t.ItemSharedID ,
        t1.Name ,
        t1.NameInvoice ,
        t1.Barcode ,
        t1.Barcodes ,
        t1.MainCategory ,
        t1.SubCategory ,
        t1.Brand ,
        t1.QtyCurrent ,
        t1.QtyCurrentByUnit ,
        t1.PurchaseF ,
        t1.PurchaseD ,
        t1.PurchaseLL ,
        t1.PurchaseEuro ,
        t1.PurchaseWithTaxF ,
        t1.PurchaseWithTaxD ,
        t1.PurchaseWithTaxLL ,
        t1.PurchaseWithTaxEuro ,
        t1.SellF ,
        t1.SellD ,
        t1.SellLL ,
        t1.SellEuro ,
        t1.SellWithTaxF ,
        t1.SellWithTaxD ,
        t1.SellWithTaxLL ,
        t1.SellWithTaxEuro ,
        t1.DescriptionAR ,
        t1.DescriptionEN ,
        t1.DescriptionSearch ,
        t1.DescriptionIs ,
        t1.UnityNames ,
        t.ProfitPartnerID ,
        t.ProfitRatio ,
        t.DateCreate ,
        t.IsSync
FROM    Items.t_ItemSharedProfitPartner AS t
INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID;






GO
