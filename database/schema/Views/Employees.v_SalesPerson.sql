SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Employees].[v_SalesPerson]
AS
SELECT  t.ID ,
        t.Name ,
        t1.ID AS AccountID ,
        t1.Name AS Account ,
        t1.NumberF ,
        t1.Balance ,
        t1.BalanceF ,
        t1.CurrencyTypeIs ,
        t.Phones ,
        t.PhonesC ,
        t.SocialMedia ,
        t.SocialMediaC ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        t.BuildingID ,
        t.Building ,
        t.FloorID ,
        t.FloorIs ,
        t.PostalCodeID ,
        t.PostalCode ,
        t.AddressNote ,
        t.AddressIs ,
        t.CommissionRate ,
        t.CommissionRateF ,
        t.CommissionRateType ,
        t.CommissionRateOn ,
        t.CommissionAvailableValueD ,
        t.CommissionAvailableValueDF ,
        t.CommissionAvailableValueLL ,
        t.CommissionAvailableValueLLF ,
        t.CommissionAvailableValueEuro ,
        t.CommissionAvailableValueEuroF ,
        t.DescriptionIs ,
        t.CustomerC ,
        t.QuotationC ,
        t.InvoicesC ,
        t.FileStorageC ,
        t.StatusIs ,
        t.WhyThisStatus ,
        t.DateCreate
FROM    Employees.t_SalesPerson AS t
        LEFT OUTER JOIN Company.t_Account AS t1 ON t.ID = t1.LinkWithID
                                                   AND t1.SectionID = 149
                                                   AND t1.NumberIs BETWEEN 4610100000 AND 4610199999;







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
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t"
            Begin Extent = 
               Top = 10
               Left = 35
               Bottom = 333
               Right = 243
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "t7"
            Begin Extent = 
               Top = 91
               Left = 466
               Bottom = 221
               Right = 636
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t6"
            Begin Extent = 
               Top = 50
               Left = 469
               Bottom = 180
               Right = 639
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t5"
            Begin Extent = 
               Top = 4
               Left = 467
               Bottom = 134
               Right = 637
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t4"
            Begin Extent = 
               Top = 133
               Left = 280
               Bottom = 263
               Right = 450
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t3"
            Begin Extent = 
               Top = 87
               Left = 281
               Bottom = 217
               Right = 451
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t2"
            Begin Extent = 
               Top = 45
               Left = 277
               Bottom = 175
               Right = 447
            End
            DisplayFlags = 344
            TopColumn = 0
       ', 'SCHEMA', N'Employees', 'VIEW', N'v_SalesPerson', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'  End
         Begin Table = "t1"
            Begin Extent = 
               Top = 3
               Left = 274
               Bottom = 214
               Right = 463
            End
            DisplayFlags = 344
            TopColumn = 3
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
', 'SCHEMA', N'Employees', 'VIEW', N'v_SalesPerson', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Employees', 'VIEW', N'v_SalesPerson', NULL, NULL
GO
