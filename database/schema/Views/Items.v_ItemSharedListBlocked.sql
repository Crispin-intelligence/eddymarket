SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Items].[v_ItemSharedListBlocked]
AS
SELECT t.ID,
       t.Name,
       t.NameInvoice,
       t.Barcode,
       t.Barcodes,
       t.MainCategory,
       t.SubCategory,
       t.Brand,
       t.QtyCurrent,
       t.IsSerial,
       t.IsExpiryDate,
       t.PurchaseF,
       t.PurchaseD,
       t.PurchaseWithTaxF,
       t.PurchaseWithTaxD,
       t.SellF,
       t.SellD,
       t.SellWithTaxF,
       t.SellWithTaxD,
       t.Discount,
       t.DescriptionAR,
       t.DescriptionEN,
       t.DescriptionSearch,
       t.DescriptionIs,
       t.StatusIs,
       t.WhyThisStatus,
       t.DateCreate
FROM Items.t_ItemShared AS t
WHERE t.StatusIs = 2;








GO
