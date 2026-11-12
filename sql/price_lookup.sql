-- Barcode -> name, USD price, LL price, stock (read-only). Source: FlexiBills2020 backup of 2026-10-25.
-- Prices are stored in USD ($); *LL columns hold the Lebanese-lira equivalent (observed rate 90,000 LL/$).
SELECT b.BarCode, i.Name, i.NameInvoice, i.MainCategory, u.Unity, u.Currency,
       u.PriceWithTax  AS PriceUSD, u.PriceWithTaxLL AS PriceLL,
       (SELECT SUM(t.QtyCurrent) FROM Items.t_Item t WHERE t.SharedID = i.ID) AS Stock
FROM Items.t_ItemSharedBarCode b
JOIN Items.t_ItemShared i ON i.ID = b.SharedID
JOIN Items.t_UnityItem  u ON u.SharedID = i.ID AND u.PrimaryIs = 1
WHERE b.BarCode = @barcode;
