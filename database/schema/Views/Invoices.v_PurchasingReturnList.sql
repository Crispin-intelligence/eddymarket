SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO











CREATE VIEW [Invoices].[v_PurchasingReturnList]
AS
SELECT t.ID ,
    t.Ref ,
    t.RefF ,
    t.RefPaper ,
    t.InvoiceTitle ,
    t.DateIs ,
    t.UserID ,
    t.UserIs ,
    t.AccountVendorID ,
    t.AccountVendor ,
    t.AccountVendorNumber ,
    t.AccountBox ,
    t.AccountBoxNumber ,
    t.PaymentMethod ,
    t.Currency ,
    t.ExchangeRate ,
    t.ExchangeRateLL ,
    t.ExchangeRateEuro ,
    t.TaxExchangeRateLL ,
    t.TaxExchangeRateEuro ,
    t.TotalF ,
    t.TotalD ,
    t.TotalLL ,
    t.TotalEuro ,
    t.DiscountIsF ,
    t.DiscountIsD ,
    t.TaxRate ,
    t.TaxValueF ,
    t.TaxValueD ,
    t.TaxValueLL ,
    t.TaxValueEuro ,
    t.NetIsF ,
    t.NetIsD ,
    t.NetIsLL ,
    t.NetIsEuro ,
    t.ProfitF ,
    t.ProfitD ,
    t.ProfitLL ,
    t.ProfitEuro ,
    t.FirstPaymentF ,
    t.FirstPaymentD ,
    t.SellF ,
    t.SellD ,
    t.Qtys ,
    t.DescriptionIs ,
    t.ItemsNames ,
    t.DateCreate ,
    t.IsSync
  FROM Invoices.t_PurchasingReturn AS t;














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
         Begin Table = "v_PurchasingReturn (Invoices)"
            Begin Extent = 
               Top = 17
               Left = 143
               Bottom = 210
               Right = 359
            End
            DisplayFlags = 280
            TopColumn = 28
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
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
', 'SCHEMA', N'Invoices', 'VIEW', N'v_PurchasingReturnList', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Invoices', 'VIEW', N'v_PurchasingReturnList', NULL, NULL
GO
