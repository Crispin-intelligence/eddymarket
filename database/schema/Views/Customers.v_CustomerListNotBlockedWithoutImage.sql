SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Customers].[v_CustomerListNotBlockedWithoutImage]
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
        t.Title ,
        t.Classification ,
        t.SalesPerson ,
        t.Nationality ,
        t.StatesIs ,
        t.RegionIs ,
        t.Street ,
        t.Building ,
        t.FloorIs ,
        t.PostalCode ,
        t.AddressNote ,
        t.AddressIs ,
        t.AddressC ,
        t.NumberCurrency ,
        t.CallAfter ,
        t.CallAfterF ,
        t.DescriptionIs ,
        t.ImageThumbnail ,
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
        t.EmployeeInternet ,
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
        t.MaximumDebtInvoiceF ,
        t.MaximumDebtInvoiceD ,
        t.FromWFP ,
        t.GroupNames ,
        t.GroupCounts ,
        t.PrescriptionC ,
        t.PrescriptionLastDate ,
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
INNER  JOIN Company.t_Account AS t1 ON t1.LinkWithID = t.ID
                                       AND t1.IsMasterLink = 1
                                       AND t1.SectionID = 15
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
               Right = 304
            End
            DisplayFlags = 280
            TopColumn = 72
         End
         Begin Table = "t1"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 248
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
', 'SCHEMA', N'Customers', 'VIEW', N'v_CustomerListNotBlockedWithoutImage', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Customers', 'VIEW', N'v_CustomerListNotBlockedWithoutImage', NULL, NULL
GO
