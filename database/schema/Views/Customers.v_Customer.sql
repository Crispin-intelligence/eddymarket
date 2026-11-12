SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Customers].[v_Customer]
AS
SELECT  t.ID ,
        t.IDNumber ,
        t.IDDoor ,
        t.Name ,
        t.NameAR ,
        t1.ID AS AccountID ,
        t1.Name AS Account ,
        t1.NumberF ,
        t1.CurrencyID AS AccountCurrencyID ,
        t1.Currency AS AccountCurrency ,
        t1.Balance ,
        t1.BalanceD ,
        t1.BalanceF ,
        t1.LimitD ,
        t1.LimitF ,
        t1.DeliveryServicesC ,
        t1.DeliveryServicesTotal ,
        t1.DeliveryServicesTotalF ,
        t1.DeliveryServicesProfit ,
        t1.DeliveryServicesProfitF ,
        t1.DeliveryServicesLastDate ,
        t1.GymSubscriptionC ,
        t1.GymSubscriptionTotal ,
        t1.GymSubscriptionTotalF ,
        t1.GymSubscriptionProfit ,
        t1.GymSubscriptionProfitF ,
        t1.GymSubscriptionLast ,
        t1.GymSubscriptionActiveTo ,
        t1.GymSubscriptionIsActive ,
        t1.GymMemberAttendanceC ,
        t1.GymMemberAttendanceLast ,
        t.Reference ,
        t.Phones ,
        t.PhonesC ,
        t.SocialMedia ,
        t.SocialMediaC ,
        t.Gender ,
        t.Birthday ,
        t.AgeIs ,
        t.AgeRangeID ,
        t.AgeRange ,
        t.TitleID ,
        t.Title ,
        t.ClassificationID ,
        t.Classification ,
        t.SalesPersonID ,
        t.SalesPerson ,
        t.NationalityID ,
        t.Nationality ,
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
        t.AddressC ,
        t.NumberCurrency ,
        t.CallAfter ,
        t.CallAfterF ,
        t.DescriptionIs ,
        t.ImageIs ,
        t.ImagePath ,
        t.ImageThumbnail ,
        t.ImageThumbnailFixed ,
        t.ImageID ,
        t.ImageIDPath ,
        t.ImageIDThumbnail ,
        t.QuotationC ,
        t.RequestC ,
        t.FeedbackC ,
        t.CallC ,
        t.FileStorageC ,
        t.RatingFeedback ,
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
        t.StatusIs ,
        t.WhyThisStatus ,
        t.LicenseInternet ,
        t.EmployeeIDInternet ,
        t.EmployeeInternet ,
        t.InternetPackageID ,
        t.InternetPackage ,
        t.StartFromInternet ,
        t.ActiveToInternet ,
        t.ActiveToDayInternet ,
        t.NotificationBeforeDaysInternet ,
        t.NotificationDateInternet ,
        t.NotificationARInternet ,
        t.NotificationENInternet ,
        t.UserNameInternet ,
        t.PasswordInternet ,
        t.InternetSubscriptionC ,
        t.InternetSubscriptionTotal ,
        t.InternetSubscriptionTotalF ,
        t.InternetSubscriptionProfit ,
        t.InternetSubscriptionProfitF ,
        t.InternetSubscriptionLast ,
        t.PricingType ,
        t.PriceIncreaseRate ,
        t.PaymentMethod ,
        t.MaximumDebtInvoiceCurrencyID ,
        t.MaximumDebtInvoiceCurrency ,
        t.MaximumDebtInvoice ,
        t.MaximumDebtInvoiceF ,
        t.MaximumDebtInvoiceD ,
        t.FromWFP ,
        t.GroupNames ,
        t.GroupCounts ,
        t.PrescriptionDoctorID ,
        t.PrescriptionDoctor ,
        t.PrescriptionBrandID ,
        t.PrescriptionBrand ,
        t.PrescriptionTypeIs ,
        t.PrescriptionFocal ,
        t.PrescriptionWithRight ,
        t.PrescriptionWithLeft ,
        t.PrescriptionSphereRight ,
        t.PrescriptionSphereLeft ,
        t.PrescriptionCylinderRight ,
        t.PrescriptionCylinderLeft ,
        t.PrescriptionAxisRight ,
        t.PrescriptionAxisLeft ,
        t.PrescriptionPrismRight ,
        t.PrescriptionPrismLeft ,
        t.PrescriptionBaseRight ,
        t.PrescriptionBaseLeft ,
        t.PrescriptionAddition ,
        t.PrescriptionHeightRight ,
        t.PrescriptionHeightLeft ,
        t.PrescriptionPDRight ,
        t.PrescriptionPDLeft ,
        t.PrescriptionPD ,
        t.PrescriptionDescriptionIs ,
        t.PrescriptionLastDate ,
        t.PrescriptionC ,
        t.FrameJobOrderC ,
        t.FrameJobOrderTotal ,
        t.FrameJobOrderTotalF ,
        t.FrameJobOrderProfit ,
        t.FrameJobOrderProfitF ,
        t.FrameJobOrderLast ,
        t.DateCreate ,
        t.IsSync ,
        t.IsSyncImage ,
        t.IsSyncImageID
FROM    Customers.t_Customer AS t
INNER  JOIN Company.t_Account AS t1 ON t1.SectionID = 15
                                       AND t1.IsMasterLink = 1
                                       AND t1.LinkWithID = t.ID;




























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
         Configuration = "(H (1[57] 2[24] 3) )"
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
         Configuration = "(H (2[66] 3) )"
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
         Configuration = "(H (1[57] 2) )"
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
         Configuration = "(V (2) )"
      End
      ActivePaneConfig = 2
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -288
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t"
            Begin Extent = 
               Top = 39
               Left = 45
               Bottom = 579
               Right = 278
            End
            DisplayFlags = 280
            TopColumn = 20
         End
         Begin Table = "t6"
            Begin Extent = 
               Top = 88
               Left = 492
               Bottom = 218
               Right = 662
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t10"
            Begin Extent = 
               Top = 141
               Left = 677
               Bottom = 271
               Right = 899
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t9"
            Begin Extent = 
               Top = 93
               Left = 674
               Bottom = 223
               Right = 884
            End
            DisplayFlags = 344
            TopColumn = 1
         End
         Begin Table = "t8"
            Begin Extent = 
               Top = 48
               Left = 673
               Bottom = 161
               Right = 869
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t7"
            Begin Extent = 
               Top = 7
               Left = 668
               Bottom = 120
               Right = 832
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t2"
            Begin Extent = 
               Top = 43
               Left = 322
               Bottom = 173
               Right = 492
            End
            DisplayFlags = 344
            TopColumn = 0
    ', 'SCHEMA', N'Customers', 'VIEW', N'v_Customer', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'    End
         Begin Table = "t1"
            Begin Extent = 
               Top = 3
               Left = 323
               Bottom = 116
               Right = 493
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t3"
            Begin Extent = 
               Top = 85
               Left = 318
               Bottom = 215
               Right = 488
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t4"
            Begin Extent = 
               Top = 3
               Left = 494
               Bottom = 116
               Right = 664
            End
            DisplayFlags = 344
            TopColumn = 1
         End
         Begin Table = "t5"
            Begin Extent = 
               Top = 45
               Left = 494
               Bottom = 158
               Right = 664
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "t11"
            Begin Extent = 
               Top = 334
               Left = 524
               Bottom = 574
               Right = 713
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
      Begin ColumnWidths = 40
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
         Width = 2775
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
         Or = 1350
      End
   End
End
', 'SCHEMA', N'Customers', 'VIEW', N'v_Customer', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Customers', 'VIEW', N'v_Customer', NULL, NULL
GO
