SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Items].[v_ItemSharedWithoutImage]
AS
SELECT  t.ID ,
        t.Name ,
        t.NameInvoice ,
        t.Barcode ,
        t.Barcodes ,
        t.MainCategoryID ,
        t.MainCategory ,
        t.SubCategoryID ,
        t.SubCategory ,
        t.BrandID ,
        t.Brand ,
        t.InList ,
        t.QtyCurrent ,
        t.QtyToReorder ,
        t.QtySalesAlert ,
        t.IsSerial ,
        t.IsExpiryDate ,
        t.LifeSpanDays ,
        t.NoticeDaysBeforeExpiryDate ,
        t.NetWeight ,
        t.GrossWeight ,
        t.SizeIs ,
        t.ColorIs ,
        t.CurrencyID ,
        t.Currency ,
        t.Purchase ,
        t.PurchaseF ,
        t.PurchaseD ,
        t.PurchaseLL ,
        t.PurchaseEuro ,
        t.PurchaseTotal ,
        t.PurchaseTotalF ,
        t.PurchaseTotalD ,
        t.PurchaseTotalLL ,
        t.PurchaseTotalEuro ,
        t.PurchaseWithTax ,
        t.PurchaseWithTaxF ,
        t.PurchaseWithTaxD ,
        t.PurchaseWithTaxLL ,
        t.PurchaseWithTaxEuro ,
        t.PurchaseTotalWithTax ,
        t.PurchaseTotalWithTaxF ,
        t.PurchaseTotalWithTaxD ,
        t.PurchaseTotalWithTaxLL ,
        t.PurchaseTotalWithTaxEuro ,
        t.SellCurrencyID ,
        t.SellCurrency ,
        t.Sell ,
        t.SellF ,
        t.SellD ,
        t.SellLL ,
        t.SellEuro ,
        t.SellTotal ,
        t.SellTotalF ,
        t.SellTotalD ,
        t.SellTotalLL ,
        t.SellTotalEuro ,
        t.SellWithTax ,
        t.SellWithTaxF ,
        t.SellWithTaxD ,
        t.SellWithTaxLL ,
        t.SellWithTaxEuro ,
        t.SellTotalWithTax ,
        t.SellTotalWithTaxF ,
        t.SellTotalWithTaxD ,
        t.SellTotalWithTaxLL ,
        t.SellTotalWithTaxEuro ,
        t.StandardSalePrice ,
        t.Discount ,
        t.DiscountF ,
        t.TaxRate ,
        t.ScaleType ,
        t.PLUNumber ,
        t.TypeIs ,
        t.ReplenishmentSystem ,
        t.MaterialsNames ,
        t.MaterialsCounts ,
        t.ImageThumbnail ,
        t.DescriptionAR ,
        t.DescriptionEN ,
        t.DescriptionSearch ,
        t.DescriptionIs ,
        t.UnityC ,
        t.UnityNames ,
        t.VendorC ,
        t.VendorNames ,
        t.PlacesNames ,
        t.FileStorageC ,
        t.AdditionalProperty1 ,
        t.AdditionalProperty2 ,
        t.AdditionalProperty3 ,
        t.AdditionalProperty4 ,
        t.AdditionalProperty5 ,
        t.AdditionalProperty6 ,
        t.AdditionalProperty7 ,
        t.AdditionalProperty8 ,
        t.AdditionalProperty9 ,
        t.AdditionalProperty10 ,
        t.DateLastSale ,
        t.DaysLastSale ,
        t.MakeInactiveAfter ,
        t.MakeInactiveAfterType ,
        t.StatusIs ,
        t.WhyThisStatus ,
        t.OpticType ,
        t.SpectacleLensesFocal ,
        t.SpectacleLensesMaterial ,
        t.SpectacleLensesUncoated ,
        t.SpectacleLensesSuperHardCoat ,
        t.SpectacleLensesAntiReflection ,
        t.SpectacleLensesUVProtection ,
        t.SpectacleLensesBlueFilterBlueControl ,
        t.SpectacleLensesPhotochromic ,
        t.SpectacleLensesBCPhotochromic ,
        t.SpectacleLensesPolariod ,
        t.SpectacleLensesTintedSolid ,
        t.SpectacleLensesTintedGradient ,
        t.SpectacleLensesTintedMirror ,
        t.SpectacleLensesIndex ,
        t.SpectacleLensesDiameter ,
        t.SpectacleLensesBase ,
        t.SpectacleLensesSphere ,
        t.SpectacleLensesCylinder ,
        t.SpectacleLensesAxis ,
        t.ContactLensesBC ,
        t.ContactLensesDIA ,
        t.ContactLensesTransparency ,
        t.ContactLensesColor ,
        t.ContactLensesType ,
        t.ContactLensesPeriod ,
        t.ContactLensesSphere ,
        t.ContactLensesCylinder ,
        t.ContactLensesAxis ,
        t.ProfitPartnersCount ,
        t.ProfitPartners ,
        t.OrderBy ,
        t.DateCreate
FROM    Items.t_ItemShared AS t;
























GO
