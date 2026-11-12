SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Transactions].[v_TransactionDetailList]
AS
SELECT t.ID,
       t.TransactionID,
       t.Account,
       t.Balance,
       t.BalanceF,
       t.BalanceD,
       t.BalanceLL,
       t.BalanceEuro,
       t.StatementIs,
       t.TypeIs,
       t.ChequeNumber,
       t.ChequeNote,
       t.ChequeDateGet,
       t.ChequeStopNotificationGet
FROM Transactions.t_TransactionDetail AS t;





GO
