SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Items].[v_ItemSharedListNotBlocked]
AS
SELECT  t.ID ,
        t.Name ,
        t.NameInvoice ,
        t.Barcode ,
        t.Barcodes ,
        t.MainCategory ,
        t.SubCategory ,
        t.Brand ,
        t.InList ,
        t.QtyCurrent ,
        t.QtyCurrentByUnit ,
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
        t.PurchaseF ,
        t.PurchaseD ,
        t.PurchaseLL ,
        t.PurchaseEuro ,
        t.PurchaseTotalF ,
        t.PurchaseTotalD ,
        t.PurchaseTotalLL ,
        t.PurchaseTotalEuro ,
        t.PurchaseWithTaxF ,
        t.PurchaseWithTaxD ,
        t.PurchaseWithTaxLL ,
        t.PurchaseWithTaxEuro ,
        t.PurchaseTotalWithTaxF ,
        t.PurchaseTotalWithTaxD ,
        t.PurchaseTotalWithTaxLL ,
        t.PurchaseTotalWithTaxEuro ,
        t.SellF ,
        t.SellD ,
        t.SellLL ,
        t.SellEuro ,
        t.SellTotalF ,
        t.SellTotalD ,
        t.SellTotalLL ,
        t.SellTotalEuro ,
        t.SellWithTaxF ,
        t.SellWithTaxD ,
        t.SellWithTaxLL ,
        t.SellWithTaxEuro ,
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
        t.ImageIs ,
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
        t.DateCreate ,
        t.IsSync ,
        t.IsSyncImage
FROM    Items.t_ItemShared AS t
WHERE   ( t.StatusIs <> 2 );











GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 82
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'Items', 'VIEW', N'v_ItemSharedListNotBlocked', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Items', 'VIEW', N'v_ItemSharedListNotBlocked', NULL, NULL
GO
