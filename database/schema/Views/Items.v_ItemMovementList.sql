SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ItemMovementList]
AS
SELECT t.ID,
       t.ID AS FatherID,
       0 AS SectionIs,
       t1.RefF,
       t1.DateIs,
       t1.AccountVendor AS Account,
       t1.AccountVendorNumber AS AccountNumber,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t2.Brand,
       t2.MainCategory,
       t2.SubCategory,
       t3.WareHouse,
       t.Qtys,
       t.QtyWithUnity,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       t.TaxRate,
       t.TaxValueD,
       t.TaxValueLL,
       t.TaxValueEuro,
       t.DiscountIs,
       t.DiscountIsValueD,
       t.DiscountIsValueLL,
       t.DiscountIsValueEuro,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       0 AS ProfitTotalD,
       0 AS ProfitTotalLL,
       0 AS ProfitTotalEuro,
       t.SortAt,
       t.DateCreate
FROM Invoices.t_PurchasingDetail AS t
    LEFT JOIN Invoices.t_Purchasing AS t1
        ON t1.ID = t.PurchasingID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t3
        ON t3.ID = t.ItemID
UNION ALL
SELECT t.ID,
       t.ID AS FatherID,
       1 AS SectionIs,
       t1.RefF,
       t1.DateIs,
       t1.AccountVendor AS Account,
       t1.AccountVendorNumber AS AccountNumber,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t2.Brand,
       t2.MainCategory,
       t2.SubCategory,
       t3.WareHouse,
       0 - t.Qtys,
       '-' + t.QtyWithUnity,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       t.TaxRate,
       t.TaxValueD,
       t.TaxValueLL,
       t.TaxValueEuro,
       t.DiscountIs,
       t.DiscountIsValueD,
       t.DiscountIsValueLL,
       t.DiscountIsValueEuro,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       0 AS ProfitTotalD,
       0 AS ProfitTotalLL,
       0 AS ProfitTotalEuro,
       t.SortAt,
       t.DateCreate
FROM Invoices.t_PurchasingReturnDetail AS t
    LEFT JOIN Invoices.t_PurchasingReturn AS t1
        ON t1.ID = t.PurchasingReturnID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t3
        ON t3.ID = t.ItemID
UNION ALL
SELECT t.ID,
       t.ID AS FatherID,
       2 AS SectionIs,
       t1.RefF,
       t1.DateIs,
       t1.AccountCustomer AS Account,
       t1.AccountCustomerNumber AS AccountNumber,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t2.Brand,
       t2.MainCategory,
       t2.SubCategory,
       t3.WareHouse,
       0 - t.Qtys,
       '-' + t.QtyWithUnity,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       t.TaxRate,
       t.TaxValueD,
       t.TaxValueLL,
       t.TaxValueEuro,
       t.DiscountIs,
       t.DiscountIsValueD,
       t.DiscountIsValueLL,
       t.DiscountIsValueEuro,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       t.ProfitTotalD,
       t.ProfitTotalLL,
       t.ProfitTotalEuro,
       t.SortAt,
       t.DateCreate
FROM Invoices.t_SoldDetail AS t
    LEFT JOIN Invoices.t_Sold AS t1
        ON t1.ID = t.SoldID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t3
        ON t3.ID = t.ItemID
UNION ALL
SELECT t.ID,
       t.ID AS FatherID,
       3 AS SectionIs,
       t1.RefF,
       t1.DateIs,
       t1.AccountCustomer AS Account,
       t1.AccountCustomerNumber AS AccountNumber,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t2.Brand,
       t2.MainCategory,
       t2.SubCategory,
       t3.WareHouse,
       t.Qtys,
       t.QtyWithUnity,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       t.TaxRate,
       t.TaxValueD,
       t.TaxValueLL,
       t.TaxValueEuro,
       t.DiscountIs,
       t.DiscountIsValueD,
       t.DiscountIsValueLL,
       t.DiscountIsValueEuro,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       0 AS ProfitTotalD,
       0 AS ProfitTotalLL,
       0 AS ProfitTotalEuro,
       t.SortAt,
       t.DateCreate
FROM Invoices.t_SoldReturnDetail AS t
    LEFT JOIN Invoices.t_SoldReturn AS t1
        ON t1.ID = t.SoldReturnID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t3
        ON t3.ID = t.ItemID
UNION ALL
SELECT t.ID,
       t.ID AS FatherID,
       7 AS SectionIs,
       t1.RefF,
       t1.DateIs,
       N'' AS Account,
       N'' AS AccountNumber,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t2.Brand,
       t2.MainCategory,
       t2.SubCategory,
       t3.WareHouse,
       t.Qtys,
       t.QtyWithUnity,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       0 AS TaxRate,
       0 AS TaxValueD,
       0 AS TaxValueLL,
       0 AS TaxValueEuro,
       0 AS DiscountIs,
       0 AS DiscountIsValueD,
       0 AS DiscountIsValueLL,
       0 AS DiscountIsValueEuro,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       0 AS ProfitTotalD,
       0 AS ProfitTotalLL,
       0 AS ProfitTotalEuro,
       t.SortAt,
       t.DateCreate
FROM Items.t_StockAdjustmentDetail AS t
    LEFT JOIN Items.t_StockAdjustment AS t1
        ON t1.ID = t.StockAdjustmentID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t3
        ON t3.ID = t.ItemID
UNION ALL
SELECT t.ID,
       t.TransferID AS FatherID,
       50 AS SectionIs,
       t1.RefF,
       t1.DateIs,
       t1.UserIs AS Account,
       N'' AS AccountNumber,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t2.Brand,
       t2.MainCategory,
       t2.SubCategory,
       t1.FromWarehouse,
       0 - t.Qtys,
       '-' + t.QtyWithUnity AS QtyWithUnity,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       t.TaxRate,
       t.TaxValueD,
       t.TaxValueLL,
       t.TaxValueEuro,
       t.DiscountIs,
       t.DiscountIsValueD,
       t.DiscountIsValueLL,
       t.DiscountIsValueEuro,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       0 AS ProfitTotalD,
       0 AS ProfitTotalLL,
       0 AS ProfitTotalEuro,
       t.SortAt,
       t.DateCreate
FROM Invoices.t_TransferDetail AS t
    LEFT JOIN Invoices.t_Transfer AS t1
        ON t1.ID = t.TransferID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
UNION ALL
SELECT t.ID1 AS ID,
       t.TransferID AS FatherID,
       50 AS SectionIs,
       t1.RefF,
       t1.DateIs,
       t1.UserIs AS Account,
       N'' AS AccountNumber,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t2.Brand,
       t2.MainCategory,
       t2.SubCategory,
       t1.ToWarehouse,
       t.Qtys,
       t.QtyWithUnity AS QtyWithUnity,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       t.TaxRate,
       t.TaxValueD,
       t.TaxValueLL,
       t.TaxValueEuro,
       t.DiscountIs,
       t.DiscountIsValueD,
       t.DiscountIsValueLL,
       t.DiscountIsValueEuro,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       0 AS ProfitTotalD,
       0 AS ProfitTotalLL,
       0 AS ProfitTotalEuro,
       t.SortAt,
       t.DateCreate
FROM Invoices.t_TransferDetail AS t
    LEFT JOIN Invoices.t_Transfer AS t1
        ON t1.ID = t.TransferID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
UNION ALL
SELECT t.ID,
       t.ID AS FatherID,
       101 AS SectionIs,
       t1.RefF,
       t1.DateIs,
       N'' AS Account,
       N'' AS AccountNumber,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t2.Brand,
       t2.MainCategory,
       t2.SubCategory,
       t3.WareHouse,
       t.Qtys,
       t.QtyWithUnity,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       0 AS TaxRate,
       0 AS TaxValueD,
       0 AS TaxValueLL,
       0 AS TaxValueEuro,
       0 AS DiscountIs,
       0 AS DiscountIsValueD,
       0 AS DiscountIsValueLL,
       0 AS DiscountIsValueEuro,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       0 AS ProfitTotalD,
       0 AS ProfitTotalLL,
       0 AS ProfitTotalEuro,
       t.SortAt,
       t.DateCreate
FROM Items.t_StockTakeDetail AS t
    LEFT JOIN Items.t_StockTake AS t1
        ON t1.ID = t.StockTakeID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t3
        ON t3.ID = t.ItemID
UNION ALL
SELECT t.ID,
       t.ID AS FatherID,
       155 AS SectionIs,
       t.RefF,
       t.DateIs,
       t.Employee AS Account,
       N'' AS AccountNumber,
       t.ItemSharedID,
       t1.Name,
       t1.Barcodes,
       t1.Brand,
       t1.MainCategory,
       t1.SubCategory,
       t2.WareHouse,
       t.Qtys,
       t.QtyWithUnity,
       t.CostD,
       t.CostLL,
       t.CostEuro,
       0 AS TaxRate,
       0 AS TaxValueD,
       0 AS TaxValueLL,
       0 AS TaxValueEuro,
       0 AS DiscountIs,
       0 AS DiscountIsValueD,
       0 AS DiscountIsValueLL,
       0 AS DiscountIsValueEuro,
       t.TotalCostD,
       t.TotalCostLL,
       t.TotalCostEuro,
       0 AS ProfitTotalD,
       0 AS ProfitTotalLL,
       0 AS ProfitTotalEuro,
       0,
       t.DateCreate
FROM Items.t_ItemProduction AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t2
        ON t2.ID = t.ItemID
UNION ALL
SELECT t.ID,
       t.ItemProductionID AS FatherID,
       155 AS SectionIs,
       t1.RefF,
       t1.DateIs,
       t1.Employee AS Account,
       N'' AS AccountNumber,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t2.Brand,
       t2.MainCategory,
       t2.SubCategory,
       t3.WareHouse,
       0 - t.Qtys,
       '-' + t.QtyWithUnity,
       t.CostD,
       t.CostLL,
       t.CostEuro,
       0 AS TaxRate,
       0 AS TaxValueD,
       0 AS TaxValueLL,
       0 AS TaxValueEuro,
       0 AS DiscountIs,
       0 AS DiscountIsValueD,
       0 AS DiscountIsValueLL,
       0 AS DiscountIsValueEuro,
       t.TotalCostD,
       t.TotalCostLL,
       t.TotalCostEuro,
       0 AS ProfitTotalD,
       0 AS ProfitTotalLL,
       0 AS ProfitTotalEuro,
       t.SortAt,
       t.DateCreate
FROM Items.t_ItemProductionMaterial AS t
    LEFT JOIN Items.t_ItemProduction AS t1
        ON t1.ID = t.ItemProductionID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t3
        ON t3.ID = t.ItemID
UNION ALL
SELECT t.ID,
       t.ID AS FatherID,
       158 AS SectionIs,
       t1.RefF,
       t1.DateIs,
       N'' AS Account,
       N'' AS AccountNumber,
       t.ItemSharedID,
       t2.Name,
       t2.Barcodes,
       t2.Brand,
       t2.MainCategory,
       t2.SubCategory,
       t3.WareHouse,
       t.Qtys,
       t.QtyWithUnity,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       0 AS TaxRate,
       0 AS TaxValueD,
       0 AS TaxValueLL,
       0 AS TaxValueEuro,
       0 AS DiscountIs,
       0 AS DiscountIsValueD,
       0 AS DiscountIsValueLL,
       0 AS DiscountIsValueEuro,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       0 AS ProfitTotalD,
       0 AS ProfitTotalLL,
       0 AS ProfitTotalEuro,
       t.SortAt,
       t.DateCreate
FROM Items.t_BeginningInventoryQuantityDetail AS t
    LEFT JOIN Items.t_BeginningInventoryQuantity AS t1
        ON t1.ID = t.BeginningInventoryQuantityID
    LEFT JOIN Items.t_ItemShared AS t2
        ON t2.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t3
        ON t3.ID = t.ItemID;














GO
