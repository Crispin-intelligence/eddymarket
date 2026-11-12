SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_SoldDetailNotWFPReported]
AS
SELECT t3.WFPShopID AS SHOP_ID,
       t3.WFPBranchID AS OUTLET_ID,
       t3.DateOnly AS DATE,
       t3.TimeOnly AS TIME,
       t3.Ref AS RECEIPT_NUMBER,
       t3.AccountCustomer AS BENEFICIARY_CODE,
       t1.Name AS ITEM_CODE,
       t1.Barcode AS BARCODE,
       t1.DescriptionIs AS SKU_DESCRIPTION,
       t.Qty AS QUANTITY,
       t.Price AS UNIT_PRICE,
       t.Total AS SALE_VALUE,
       t.DiscountIsValue AS VALUE_OF_DISCOUNT,
       t.DiscountIsF AS DISCOUNT_PERCENTAGE,
       t3.Currency AS CURRENCY,
       t.TaxValue AS TAX_VALUE,
       t.TaxRateF AS TAX_PERCENTAGE,
       t3.PaymentMethod AS PAYMENT_METHOD,
       t1.NetWeight AS ITEM_WEIGHT,
       t2.Unity AS UNIT_MEASURE_WEIGHT,
       t2.Qty AS PACKAGING_UNITS,
       t1.DescriptionEN AS SKU_ENGLISH_DESCRIPTION,
       t1.MainCategory AS CATEGORY,
       t1.Brand AS BRAND,
       t1.VendorNames AS SUPPLIER
FROM Invoices.t_SoldDetail AS t
    INNER JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID
    INNER JOIN Items.t_UnityItem AS t2
        ON t2.ID = t.ItemUnityID
    INNER JOIN Invoices.t_Sold AS t3
        ON t3.ID = t.SoldID
WHERE t3.WFPFrom = 1
      AND t3.WFPReported = 0;





GO
