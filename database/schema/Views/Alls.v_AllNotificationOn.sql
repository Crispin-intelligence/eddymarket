SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Alls].[v_AllNotificationOn]
AS
SELECT  4 AS SectionID ,
        t.ID ,
        t.ID AS FatherID ,
        t.RefF ,
        t.DateIs ,
        t.NotificationTextAR AS TextAR ,
        t.NotificationTextEN AS TextEN ,
        t.NotificationStop AS IsStop ,
        N'' AS MyNote
FROM    Quotations.t_Quotation AS t
WHERE   t.NotificationDate <= GETDATE()
        AND t.NotificationStop = 0
UNION ALL
SELECT  10 AS SectionID ,
        t.ID ,
        t.SharedID AS FatherID ,
        t1.Name AS RefF ,
        GETDATE() AS DateIs ,
        'نحتاج شراء ' + FORMAT(t.QtyToReorder - t.QtyCurrent, '#,##0.##') + ' قطعة من (' + t1.Name + ') للمستودع (' + t.WareHouse + ')' AS TextAR ,
        'We Need to Buy ' + FORMAT(t.QtyToReorder - t.QtyCurrent, '#,##0.##') + ' Pieces of (' + t1.Name + ') For Warehouse (' + t.WareHouse + ')' AS TextEN ,
        CONVERT(BIT, 0) AS IsStop ,
        N'Item' AS MyNote
FROM    Items.t_Item AS t
        LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.SharedID
WHERE   t.QtyToReorder > 0
        AND t.QtyToReorder > t.QtyCurrent
UNION ALL
SELECT  10 AS SectionID ,
        t.ID1 ,
        t.ID AS FatherID ,
        t1.Name AS RefF ,
        t.StockTakeEveryNotificationDate AS DateIs ,
        N'حان الوقت لإجراء جرد (' + t1.Name + ') الموجود في (' + t.WareHouse + ') في (' + t.Place + N')' AS TextAR ,
        N'It Is Time to Do Stocktake for The (' + t1.Name + ') in The (' + t.WareHouse + ') in The (' + t.Place + N')' AS TextEN ,
        CONVERT(BIT, 0) AS IsStop ,
        N'Stocktake' AS MyNote
FROM    Items.t_Item AS t
        LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.SharedID
WHERE   t.StockTakeEveryNotificationDate <= CONVERT(DATE, GETDATE())
        AND t.StockTakeEvery > 0
UNION ALL
SELECT  10 AS SectionID ,
        t.ID ,
        t.ID AS FatherID ,
        t.Name AS RefF ,
        GETDATE() AS DateIs ,
        N'هذا الصنف' + N' (' + t.Name + N') ' + N'غير نشط' TextAR ,
        N'This Item' + N' (' + t.Name + N') ' + N'Is Not Active' TextEN ,
        CONVERT(BIT, 0) AS IsStop ,
        N'ItemShared' AS MyNote
FROM    Items.t_ItemShared AS t
WHERE   t.StatusIs = 1
UNION ALL
SELECT  168 ,
        t.ID ,
        t.ItemSharedID ,
        t.RefF ,
        t.NotificationDate ,
        CASE WHEN t.ExpirationDate < CONVERT(DATE, GETDATE()) THEN N'إنتهت صلاحية ' + t1.Name + FORMAT(t.Qtys, N' x#,##0.####') + ' في ' + FORMAT(t.ExpirationDate, 'dd-MM-yyyy')
             WHEN t.ExpirationDate = CONVERT(DATE, GETDATE()) THEN N'ستنتهي صلاحية ' + t1.Name + FORMAT(t.Qtys, N' x#,##0.####') + ' اليوم'
             ELSE N'سوف تنتهي صلاحية ' + t1.Name + FORMAT(t.Qtys, N' x#,##0.####') + ' في ' + FORMAT(t.ExpirationDate, 'dd-MM-yyyy')
        END AS NotificationTextAR ,
        CASE WHEN t.ExpirationDate < CONVERT(DATE, GETDATE()) THEN t1.Name + FORMAT(t.Qtys, N' x#,##0.####') + N' Has Expired in ' + FORMAT(t.ExpirationDate, 'dd-MM-yyyy')
             WHEN t.ExpirationDate = CONVERT(DATE, GETDATE()) THEN t1.Name + FORMAT(t.Qtys, N' x#,##0.####') + N' Will Expire Today '
             ELSE t1.Name + FORMAT(t.Qtys, N' x#,##0.####') + N' Will Expire in ' + FORMAT(t.ExpirationDate, 'dd-MM-yyyy')
        END AS NotificationTextEN ,
        CONVERT(BIT, 0) AS IsStop ,
        N'' AS MyNote
FROM    Items.t_ItemExpirationDate AS t
        LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
WHERE   t.NotificationDate <= CONVERT(DATE, GETDATE())
UNION ALL
SELECT  65 ,
        t.ID ,
        t.TransactionID ,
        t1.RefF ,
        t1.DateOnly ,
        t.NotificationTextAR ,
        t.NotificationTextEN ,
        t.ChequeStopNotificationGet ,
        N'' AS MyNote
FROM    Transactions.t_TransactionDetail AS t
        LEFT JOIN Transactions.t_Transaction AS t1 ON t1.ID = t.TransactionID
WHERE   t.TypeIs = 1
        AND t.ChequeDateGet <= GETDATE()
        AND t1.TypeIs = 'JV'
        AND t.ChequeStopNotificationGet = 0
UNION ALL
SELECT  72 ,
        t.ID ,
        t.ID ,
        t.Name ,
        t.ExpirationDate ,
        t.NotificationAR ,
        t.NotificationEN ,
        t.StopNotification ,
        N'' AS MyNote
FROM    Company.t_FileStorage AS t
WHERE   t.ExpirationDate <= GETDATE()
        AND t.StopNotification = 0
UNION ALL
SELECT  81 ,
        t.ID ,
        t.ID ,
        t.RefF ,
        t.DateIs ,
        t.NotificationTextAR ,
        t.NotificationTextEN ,
        t.NotificationStop ,
        N'' AS MyNote
FROM    Company.t_Cheque AS t
WHERE   t.NotificationDate <= GETDATE()
        AND t.NotificationStop = 0
UNION ALL
SELECT  96 ,
        t.ID ,
        t.TransactionID ,
        t1.RefF ,
        t1.DateOnly ,
        t.NotificationTextAR ,
        t.NotificationTextEN ,
        t.ChequeStopNotificationGet ,
        N'' AS MyNote
FROM    Transactions.t_TransactionDetail AS t
        LEFT JOIN Transactions.t_Transaction AS t1 ON t1.ID = t.TransactionID
WHERE   t.TypeIs = 1
        AND t.ChequeDateGet <= GETDATE()
        AND t.Balance <= 0
        AND t1.TypeIs = 'PV'
        AND t.ChequeStopNotificationGet = 0
UNION ALL
SELECT  97 ,
        t.ID ,
        t.TransactionID ,
        t1.RefF ,
        t1.DateOnly ,
        t.NotificationTextAR ,
        t.NotificationTextEN ,
        t.ChequeStopNotificationGet ,
        N'' AS MyNote
FROM    Transactions.t_TransactionDetail AS t
        LEFT JOIN Transactions.t_Transaction AS t1 ON t1.ID = t.TransactionID
WHERE   t.TypeIs = 1
        AND t.ChequeDateGet <= GETDATE()
        AND t.Balance <= 0
        AND t1.TypeIs = 'RV'
        AND t.ChequeStopNotificationGet = 0
UNION ALL
SELECT  110 ,
        t.ID ,
        t.ID ,
        t.RefF ,
        t.DateIs ,
        t.TextIs ,
        t.TextIs ,
        t.IsStop ,
        N'' AS MyNote
FROM    Alls.t_Notification AS t
WHERE   t.DateIs <= GETDATE()
        AND t.IsStop = 0
UNION ALL
SELECT  112 ,
        t.ID ,
        t.ID ,
        t.RefF ,
        t.DateIs ,
        t.NotificationTextAR ,
        t.NotificationTextEN ,
        t.NotificationStop ,
        N'' AS MyNote
FROM    Company.t_Bond AS t
WHERE   t.NotificationDate <= GETDATE()
        AND t.NotificationStop = 0
        AND t.IsPaid = 0
UNION ALL
SELECT  15 ,
        t.ID ,
        t.ID ,
        t.Name ,
        t.NotificationDateInternet ,
        CASE WHEN t.ActiveToInternet >= GETDATE() THEN t.NotificationARInternet + FORMAT(t.ActiveToInternet, 'dd-MM-yyyy')
             ELSE N'اشتراك الإنترنت منتهي الصلاحية من: ' + FORMAT(t.ActiveToInternet, 'dd-MM-yyyy')
        END ,
        CASE WHEN t.ActiveToInternet >= GETDATE() THEN t.NotificationENInternet + FORMAT(t.ActiveToInternet, 'dd-MM-yyyy')
             ELSE N'The Internet Subscription Has Expired From: ' + FORMAT(t.ActiveToInternet, 'dd-MM-yyyy')
        END ,
        CONVERT(BIT, 0) ,
        N'InternetSubscription' AS MyNote
FROM    Customers.t_Customer AS t
WHERE   t.NotificationDateInternet <= GETDATE()
        AND t.StatusIs = 0
        AND t.LicenseInternet = 1
        AND t.NotificationBeforeDaysInternet <> 0
UNION ALL
SELECT  169 ,
        t.ID ,
        t.ID ,
        t.RefF ,
        t.DateIs ,
        N'لماذا لم ينتهي إنتاج الطلب الخاص بالزبون ' + t.Customer + ' بعد؟' ,
        N'Why Is the Production of the Customer ' + t.Customer + ' Order Not Finished yet?' ,
        CONVERT(BIT, 0) ,
        N'' AS MyNote
FROM    Customers.t_FrameJobOrder AS t
WHERE   t.DateInProcessNotification <= GETDATE()
        AND t.StatusIs = 1
UNION ALL
SELECT  169 ,
        t.ID ,
        t.ID ,
        t.RefF ,
        t.DateIs ,
        N'لماذا لم يتم تسليم الطلب إلى ' + t.Customer + ' بعد؟' ,
        N'Why Was the Order Not Delivered to ' + t.Customer + ' yet?' ,
        CONVERT(BIT, 0) ,
        N'' AS MyNote
FROM    Customers.t_FrameJobOrder AS t
WHERE   t.DateReadyNotification <= GETDATE()
        AND t.StatusIs = 2;		
		
		
		



GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[13] 3) )"
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
         Begin Table = "v_AllNotification (Alls)"
            Begin Extent = 
               Top = 32
               Left = 162
               Bottom = 211
               Right = 332
            End
            DisplayFlags = 280
            TopColumn = 2
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
', 'SCHEMA', N'Alls', 'VIEW', N'v_AllNotificationOn', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Alls', 'VIEW', N'v_AllNotificationOn', NULL, NULL
GO
