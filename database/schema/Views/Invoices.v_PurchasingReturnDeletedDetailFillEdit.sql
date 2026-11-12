SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_PurchasingReturnDeletedDetailFillEdit]
AS
SELECT t.ID,
       t.PurchasingReturnDeletedID,
       t.ItemSharedID,
       t.ItemID,
       t1.Name,
       t1.Barcode,
	   t1.BrandID,
	   t1.Brand,
       t.ItemUnityID,
       t4.Name AS Unity,
       t3.Qty AS UnityQty,
       t.Qty,
       t2.WareHouseID,
       t2.WareHouse,
       t.Price,
       t.TaxRate,
       t.TaxValue,
       t.DiscountIs,
       t.DiscountIsValue,
	   t.Total,
       t.Sell,
       t.Profit,
       t.ProfitTotal,
       t.DescriptionIs,
       t1.IsSerial,
       t1.QtyCurrent,
       t.SortAt
FROM Invoices.t_PurchasingReturnDeletedDetail AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t2
        ON t2.ID = t.ItemID
    LEFT JOIN Items.t_UnityItem AS t3
        ON t3.ID = t.ItemUnityID
    LEFT JOIN Items.t_Unity AS t4
        ON t4.ID = t3.UnityID;






GO
