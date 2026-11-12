SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Items].[v_ItemProductionList]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
	   t.RefPaper,
	   t.SoldID,
	   t.SoldRef,
	   t.SoldRefF,
	   t.SoldDetailID,
       t.DateIs,
       t.DateOnly,
       t.DateMonthly,
       t.DateYearly,
	   t.EmployeeID,
	   t.Employee,
       t.ItemSharedID,
       t1.Name,
       t1.Barcode,
       t1.Barcodes,
       t.ItemID,
       t.ItemUnityID,
       t2.Unity,
       t.Qty,
       t.QtyWithUnity,
       t.Qtys,
       t.WarehouseID,
       t.Warehouse,
       t.CurrencyID,
       t.Currency,
       t.ExchangeRate,
       t.ExchangeRateLL,
       t.ExchangeRateEuro,
       t.Cost,
       t.CostF,
       t.CostD,
       t.CostLL,
       t.CostEuro,
       t.TotalCost,
       t.TotalCostF,
       t.TotalCostD,
       t.TotalCostLL,
       t.TotalCostEuro,
       t.ItemsNames,
       t.ItemsCounts,
       t.DescriptionIs,
       t.DateCreate,
       t.CreateByID,
       t.CreateBy,
	   t.HaveSerial,
	   t.IsSync
FROM Items.t_ItemProduction AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID
    LEFT JOIN Items.t_UnityItem AS t2
        ON t2.ID = t.ItemUnityID;










GO
