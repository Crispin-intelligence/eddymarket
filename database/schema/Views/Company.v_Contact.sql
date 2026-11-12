SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_Contact]
AS
SELECT t.ID,
       t.Name,
       t.Phones,
       t.PhonesC,
       t.SocialMedia,
       t.SocialMediaC,
       t.Gender,
       t.NationalityID,
       t.Nationality,
       t.TitleID,
       t.Title,
       t.ClassificationID,
       t.Classification,
       t.Birthday,
       t.AgeIs,
       t.StatesID,
       t.StatesIs,
       t.RegionID,
       t.RegionIs,
       t.StreetID,
       t.Street,
       t.BuildingID,
       t.Building,
       t.FloorID,
       t.FloorIs,
       t.PostalCodeID,
       t.PostalCode,
       t.AddressNote,
       t.AddressIs,
       t.DescriptionIs,
       t.ImageIs,
       t.DateCreate
FROM Company.t_Contact AS t;

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
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t"
            Begin Extent = 
               Top = 0
               Left = 7
               Bottom = 282
               Right = 177
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "t9"
            Begin Extent = 
               Top = 133
               Left = 369
               Bottom = 263
               Right = 539
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t8"
            Begin Extent = 
               Top = 90
               Left = 367
               Bottom = 220
               Right = 537
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t7"
            Begin Extent = 
               Top = 52
               Left = 366
               Bottom = 182
               Right = 536
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t6"
            Begin Extent = 
               Top = 2
               Left = 364
               Bottom = 132
               Right = 534
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t4"
            Begin Extent = 
               Top = 128
               Left = 197
               Bottom = 258
               Right = 367
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t5"
            Begin Extent = 
               Top = 161
               Left = 197
               Bottom = 291
               Right = 367
            End
            DisplayFlags = 344
            TopColumn = 0
         E', 'SCHEMA', N'Company', 'VIEW', N'v_Contact', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'nd
         Begin Table = "t1"
            Begin Extent = 
               Top = 2
               Left = 195
               Bottom = 132
               Right = 365
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t2"
            Begin Extent = 
               Top = 46
               Left = 198
               Bottom = 176
               Right = 368
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t3"
            Begin Extent = 
               Top = 87
               Left = 198
               Bottom = 217
               Right = 368
            End
            DisplayFlags = 344
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 21
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
', 'SCHEMA', N'Company', 'VIEW', N'v_Contact', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Company', 'VIEW', N'v_Contact', NULL, NULL
GO
