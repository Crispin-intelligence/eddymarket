SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Invoices].[v_PurchasingReturnDetail]
AS
SELECT t.ID ,
    t.PurchasingReturnID ,
    t.ItemSharedID ,
	t1.BrandID,
	t1.MainCategoryID,
	t1.SubCategoryID,
    t.ItemID ,
    t.ItemUnityID ,
    t.Qty ,
    t.QtyWithUnity ,
    t.Qtys ,
    t.Price ,
    t.PriceF ,
    t.PriceD ,
    t.PriceLL ,
    t.PriceEuro ,
    t.DiscountIs ,
    t.DiscountIsF ,
    t.DiscountIsValue ,
    t.DiscountIsValueF ,
    t.DiscountIsValueD ,
    t.DiscountIsValueLL ,
    t.DiscountIsValueEuro ,
    t.SubTotal ,
    t.SubTotalF ,
    t.SubTotalD ,
    t.SubTotalLL ,
    t.SubTotalEuro ,
    t.DiscountInvoice ,
    t.DiscountInvoiceF ,
    t.DiscountInvoiceD ,
    t.DiscountInvoiceLL ,
    t.DiscountInvoiceEuro ,
    t.TaxRate ,
    t.TaxRateF ,
    t.TaxValue ,
    t.TaxValueF ,
    t.TaxValueD ,
    t.TaxValueLL ,
    t.TaxValueEuro ,
    t.Total ,
    t.TotalF ,
    t.TotalD ,
    t.TotalLL ,
    t.TotalEuro ,
    t.Sell ,
    t.SellF ,
    t.SellD ,
    t.SellLL ,
    t.SellEuro ,
    t.Profit ,
    t.ProfitF ,
    t.ProfitD ,
    t.ProfitLL ,
    t.ProfitEuro ,
    t.ProfitTotal ,
    t.ProfitTotalF ,
    t.ProfitTotalD ,
    t.ProfitTotalLL ,
    t.ProfitTotalEuro ,
    t.DescriptionIs ,
    t.SortAt ,
    t.DateCreate ,
    t.IsSync
  FROM Invoices.t_PurchasingReturnDetail AS t
  INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID;







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
         Configuration = "(H (1[50] 2[25] 3) )"
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
      ActivePaneConfig = 10
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t"
            Begin Extent = 
               Top = 13
               Left = 28
               Bottom = 278
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 12
         End
         Begin Table = "t2"
            Begin Extent = 
               Top = 120
               Left = 368
               Bottom = 340
               Right = 538
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t2t1"
            Begin Extent = 
               Top = 116
               Left = 617
               Bottom = 246
               Right = 808
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t1t2"
            Begin Extent = 
               Top = 53
               Left = 653
               Bottom = 183
               Right = 823
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t1"
            Begin Extent = 
               Top = 19
               Left = 255
               Bottom = 232
               Right = 435
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t1t1"
            Begin Extent = 
               Top = 10
               Left = 678
               Bottom = 196
               Right = 858
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t3"
            Begin Extent = 
               Top = 142
               Left = 413
               Bottom = 327
               Right = 591
            End
            DisplayFlags = 280
            TopColumn = 5
', 'SCHEMA', N'Invoices', 'VIEW', N'v_PurchasingReturnDetail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
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
', 'SCHEMA', N'Invoices', 'VIEW', N'v_PurchasingReturnDetail', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Invoices', 'VIEW', N'v_PurchasingReturnDetail', NULL, NULL
GO
