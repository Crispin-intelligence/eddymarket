SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Transactions].[v_TransactionDetailReport]
AS
SELECT t.ID,
       t.RowNumber,
       t.TransactionID,
	   t.AccountID,
       t.Account,
       t1.NumberF,
       t.Balance,
       t.BalanceF,
       t.BalanceD,
       t.StatementIs,
       t.TypeIs,
       t.ChequeNumber,
       t.ChequeNote,
       t.ChequeDateGet,
       t.ChequeStopNotificationGet
FROM Transactions.t_TransactionDetail AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.AccountID;





GO
