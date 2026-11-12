SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Company].[v_AccountList]
AS
SELECT t.ID ,
    t.SectionID ,
    t.LinkWithID ,
    t.LinkWith ,
    t.NumberF ,
    t.NumberIs ,
    t.NumberNet ,
    t.Name ,
    t.Balance ,
    t.BalanceF ,
    t.BalanceD ,
    t.BalanceLL ,
    t.BalanceEuro ,
    t.LimitF ,
    t.LimitD ,
    t.ShowInGymClass ,
    t.ShowInPersonalTrainer ,
    t.DescriptionIs ,
    t.UserBlockedC ,
    t.UsersNames ,
    t.AccountMergeC ,
    t.AccountMergeNames ,
    t.StatusIs ,
    t.WhyThisStatus ,
    t.LastAction ,
    t.MakeInactiveAfter ,
    t.MakeInactiveAfterType ,
    t.DeliveryServicesC ,
    t.DeliveryServicesTotal ,
    t.DeliveryServicesTotalF ,
    t.DeliveryServicesProfit ,
    t.DeliveryServicesProfitF ,
    t.DeliveryServicesLastDate ,
    t.PurchasingC ,
    t.PurchasingTotal ,
    t.PurchasingTotalF ,
    t.PurchasingProfit ,
    t.PurchasingProfitF ,
    t.PurchasingLast ,
    t.PurchasingReturnC ,
    t.PurchasingReturnTotal ,
    t.PurchasingReturnTotalF ,
    t.PurchasingReturnProfit ,
    t.PurchasingReturnProfitF ,
    t.PurchasingReturnLast ,
    t.SoldC ,
    t.SoldTotal ,
    t.SoldTotalF ,
    t.SoldProfit ,
    t.SoldProfitF ,
    t.SoldLast ,
    t.SoldReturnC ,
    t.SoldReturnTotal ,
    t.SoldReturnTotalF ,
    t.SoldReturnProfit ,
    t.SoldReturnProfitF ,
    t.SoldReturnLast ,
    t.QuotationC ,
    t.QuotationTotal ,
    t.QuotationTotalF ,
    t.QuotationProfit ,
    t.QuotationProfitF ,
    t.QuotationLast ,
    t.GymSubscriptionC ,
    t.GymSubscriptionTotal ,
    t.GymSubscriptionTotalF ,
    t.GymSubscriptionProfit ,
    t.GymSubscriptionProfitF ,
    t.GymSubscriptionLast ,
    t.GymSubscriptionActiveTo ,
    t.GymSubscriptionIsActive ,
    t.GymMemberAttendanceC ,
    t.GymMemberAttendanceLast ,
    t.DateCreate ,
    t.IsSync
  FROM Company.t_Account AS t;
















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
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Top = -288
         Left = 0
      End
      Begin Tables = 
         Begin Table = "v_Account (Company)"
            Begin Extent = 
               Top = 27
               Left = 92
               Bottom = 350
               Right = 281
            End
            DisplayFlags = 280
            TopColumn = 9
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
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
', 'SCHEMA', N'Company', 'VIEW', N'v_AccountList', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Company', 'VIEW', N'v_AccountList', NULL, NULL
GO
