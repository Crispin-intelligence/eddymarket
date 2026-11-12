SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_Shift]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.EmployeeID,
       t.Employee,
       t.DateIs,
       t.FromIsMust,
       t.FromIs,
       t.ShiftMinuteMust,
       t.ShiftHourMust,
       t.ShiftMustF,
       t.EarlyMinute,
       t.EarlyF,
       t.CalculationEarly,
       t.LateMinute,
       t.LateF,
       t.LateX,
       t.LateMinuteNet,
       t.LateNetF,
       t.LateMinuteExtra,
       t.LateExtraF,
       t.ToIsMust,
       t.ToIs,
       t.ShiftMinute,
       t.ShiftHour,
       t.ShiftF,
       t.OverTimeMinute,
       t.OverTimeF,
       t.CalculationOverTime,
       t.OverTimeX,
       t.OverTimeMinuteNet,
       t.OverTimeNetF,
       t.OverTimeMinuteExtra,
       t.OverTimeExtraF,
       t.ShiftMinuteNet,
       t.ShiftHourNet,
       t.ShiftNetF,
       t.TimeIncompleteMinute,
       t.TimeIncompleteF,
       t.DescriptionIs,
       t.StatusIs,
       t.DateCreate
FROM Employees.t_Shift AS t;


GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'350
      End
   End
End
', 'SCHEMA', N'Employees', 'VIEW', N'v_Shift', NULL, NULL
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
         Configuration = "(H (1[75] 4) )"
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
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t"
            Begin Extent = 
               Top = 15
               Left = 41
               Bottom = 355
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "t1"
            Begin Extent = 
               Top = 12
               Left = 316
               Bottom = 142
               Right = 549
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 32
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
         Or = 1', 'SCHEMA', N'Employees', 'VIEW', N'v_Shift', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1

GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Employees', 'VIEW', N'v_Shift', NULL, NULL
GO
