SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_BeginningInventoryQuantityDetail]
AS
SELECT t.ID,
       t.BeginningInventoryQuantityID,
       t.ItemSharedID,
       t.ItemID,
       t.ItemUnityID,
       t.Qty,
       t.QtyWithUnity,
       t.Qtys,
       t.Price,
       t.PriceF,
       t.PriceD,
       t.PriceLL,
       t.PriceEuro,
       t.Total,
       t.TotalF,
       t.TotalD,
       t.TotalLL,
       t.TotalEuro,
       t.DescriptionIs,
       t.SortAt,
       t.DateCreate
FROM Items.t_BeginningInventoryQuantityDetail AS t;


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
      ActivePaneConfig = 2
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = -362
      End
      Begin Tables = 
         Begin Table = "t"
            Begin Extent = 
               Top = 11
               Left = 39
               Bottom = 211
               Right = 289
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "t2"
            Begin Extent = 
               Top = 63
               Left = 411
               Bottom = 231
               Right = 581
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t2s1"
            Begin Extent = 
               Top = 127
               Left = 632
               Bottom = 257
               Right = 823
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t1s2"
            Begin Extent = 
               Top = 161
               Left = 881
               Bottom = 291
               Right = 1051
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t1"
            Begin Extent = 
               Top = 5
               Left = 367
               Bottom = 191
               Right = 617
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t1s1"
            Begin Extent = 
               Top = 2
               Left = 858
               Bottom = 180
               Right = 1108
            End
            DisplayFlags = 280
            TopColumn = 10
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 23
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
  ', 'SCHEMA', N'Items', 'VIEW', N'v_BeginningInventoryQuantityDetail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'    Width = 1500
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
', 'SCHEMA', N'Items', 'VIEW', N'v_BeginningInventoryQuantityDetail', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Items', 'VIEW', N'v_BeginningInventoryQuantityDetail', NULL, NULL
GO
