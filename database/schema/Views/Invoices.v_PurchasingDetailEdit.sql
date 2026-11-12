SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_PurchasingDetailEdit]
AS
SELECT t.ID,
       t.PurchasingID,
       t1.Name,
       t1.Barcode,
       t2.WareHouse,
       t.Qty,
       t4.Name AS Unity,
       t.Price,
       t.PriceF,
       t.Sell,
       t.SellF,
       t.TaxRate,
       t.TaxRateF,
       t.DiscountIs,
       t.DiscountIsF,
       t.DescriptionIs,
       t.SortAt
FROM Invoices.t_PurchasingDetail AS t
    LEFT JOIN Items.t_ItemShared AS t1
        ON t1.ID = t.ItemSharedID
    LEFT JOIN Items.t_Item AS t2
        ON t2.ID = t.ItemID
    LEFT JOIN Items.t_UnityItem AS t3
        ON t3.ID = t.ItemUnityID
    LEFT JOIN Items.t_Unity AS t4
        ON t4.ID = t3.UnityID;


GO
