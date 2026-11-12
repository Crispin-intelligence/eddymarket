SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Alls].[v_AllNotificationOff]
AS
SELECT 4 AS SectionID,
       t.ID,
       t.ID AS FatherID,
       t.RefF,
       t.DateIs,
       t.NotificationTextAR AS TextAR,
       t.NotificationTextEN AS TextEN,
       t.NotificationStop AS IsStop,
	   N'' AS MyNote
FROM Quotations.t_Quotation AS t
WHERE t.NotificationDate <= GETDATE()
      AND t.NotificationStop = 1
UNION ALL
SELECT 65,
       t.ID,
       t.TransactionID,
       t1.RefF,
       t1.DateOnly,
       t.NotificationTextAR,
       t.NotificationTextEN,
       t.ChequeStopNotificationGet,
	   N'' AS MyNote
FROM Transactions.t_TransactionDetail AS t
    LEFT JOIN Transactions.t_Transaction AS t1
        ON t1.ID = t.TransactionID
WHERE t.TypeIs = 1
      AND t.ChequeDateGet <= GETDATE()
      AND t1.TypeIs = 'JV'
      AND t.ChequeStopNotificationGet = 1
UNION ALL
SELECT 72,
       t.ID,
       t.ID,
       t.Name,
       t.ExpirationDate,
       t.NotificationAR,
       t.NotificationEN,
       t.StopNotification,
	   N'' AS MyNote
FROM Company.t_FileStorage AS t
WHERE t.ExpirationDate <= GETDATE()
      AND t.StopNotification = 1
UNION ALL
SELECT 81,
       t.ID,
       t.ID,
       t.RefF,
       t.DateIs,
       t.NotificationTextAR,
       t.NotificationTextEN,
       t.NotificationStop,
	   N'' AS MyNote
FROM Company.t_Cheque AS t
WHERE t.NotificationDate <= GETDATE()
      AND t.NotificationStop = 1
UNION ALL
SELECT 96,
       t.ID,
       t.TransactionID,
       t1.RefF,
       t1.DateOnly,
       t.NotificationTextAR,
       t.NotificationTextEN,
       t.ChequeStopNotificationGet,
	   N'' AS MyNote
FROM Transactions.t_TransactionDetail AS t
    LEFT JOIN Transactions.t_Transaction AS t1
        ON t1.ID = t.TransactionID
WHERE t.TypeIs = 1
      AND t.ChequeDateGet <= GETDATE()
      AND t.Balance <= 0
      AND t1.TypeIs = 'PV'
      AND t.ChequeStopNotificationGet = 1
UNION ALL
SELECT 97,
       t.ID,
       t.TransactionID,
       t1.RefF,
       t1.DateOnly,
       t.NotificationTextAR,
       t.NotificationTextEN,
       t.ChequeStopNotificationGet,
	   N'' AS MyNote
FROM Transactions.t_TransactionDetail AS t
    LEFT JOIN Transactions.t_Transaction AS t1
        ON t1.ID = t.TransactionID
WHERE t.TypeIs = 1
      AND t.ChequeDateGet <= GETDATE()
      AND t.Balance <= 0
      AND t1.TypeIs = 'RV'
      AND t.ChequeStopNotificationGet = 1
UNION ALL
SELECT 110,
       t.ID,
       t.ID,
       t.RefF,
       t.DateIs,
       t.TextIs,
       t.TextIs,
       t.IsStop,
	   N'' AS MyNote
FROM Alls.t_Notification AS t
WHERE t.DateIs <= GETDATE()
      AND t.IsStop = 1
UNION ALL
SELECT 112,
       t.ID,
       t.ID,
       t.RefF,
       t.DateIs,
       t.NotificationTextAR,
       t.NotificationTextEN,
       t.NotificationStop,
	   N'' AS MyNote
FROM Company.t_Bond AS t
WHERE t.NotificationDate <= GETDATE()
      AND t.NotificationStop = 1;









GO
