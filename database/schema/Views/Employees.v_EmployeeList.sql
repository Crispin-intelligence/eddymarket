SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Employees].[v_EmployeeList]
AS
SELECT t.ID ,
    t.Name ,
    t1.Name AS Account ,
    t1.NumberF ,
    t1.BalanceF ,
    t1.ShowInGymClass ,
    t1.ShowInPersonalTrainer ,
    t.Phones ,
    t.PhonesC ,
    t.SocialMedia ,
    t.SocialMediaC ,
    t.TypeIs ,
    t.Gender ,
    t.Nationality ,
    t.Birthday ,
    t.AgeIs ,
    t.StatesIs ,
    t.RegionIs ,
    t.Street ,
    t.Building ,
    t.FloorIs ,
    t.PostalCode ,
    t.AddressNote ,
    t.AddressIs ,
    t.DateWork ,
    t.DescriptionIs ,
    t.ImageIs ,
    t.ImageID ,
    t.IDFingerPrint ,
    t.SalaryIs ,
    t.SalaryIsF ,
    t.SalaryDeliveryService ,
    t.SalaryDeliveryServiceF ,
    t.DaysWork ,
    t.DaysWorkHours ,
    t.TotalHoursFree ,
    t.TotalHoursMustWork ,
    t.SalaryHours ,
    t.SalaryHoursF ,
    t.VacationDay ,
    t.HoursLateX ,
    t.HoursOverX ,
    t.CalculationEarly ,
    t.CalculationOverTime ,
    t.ShiftFrom ,
    t.ShiftTo ,
    t.InWorkNow ,
    t.VacationAvailableC ,
    t.TotalExitEntryPermission ,
    t.DiscountAvailableF ,
    t.BonusAvailable ,
    t.BonusAvailableF ,
    t.RequestC ,
    t.FileStorageC ,
    t.FeedbackC ,
    t.StatusIs ,
    t.WhyThisStatus ,
    t.DateCreate ,
    t.IsSync ,
    t.IsSyncImage ,
    t.IsSyncImageID
  FROM Employees.t_Employee AS t
  LEFT OUTER JOIN Company.t_Account AS t1 ON t.ID = t1.LinkWithID AND t1.SectionID = 33 AND t1.NumberIs BETWEEN 4210100000 AND 4219999999;






GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'   PaneHidden = 
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
', 'SCHEMA', N'Employees', 'VIEW', N'v_EmployeeList', NULL, NULL
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
         Configuration = "(H (1[57] 2[19] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[56] 3) )"
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
               Top = 198
               Left = 38
               Bottom = 328
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t1"
            Begin Extent = 
               Top = 207
               Left = 391
               Bottom = 337
               Right = 580
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
      Begin ColumnWidths = 47
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
   ', 'SCHEMA', N'Employees', 'VIEW', N'v_EmployeeList', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1

GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Employees', 'VIEW', N'v_EmployeeList', NULL, NULL
GO
