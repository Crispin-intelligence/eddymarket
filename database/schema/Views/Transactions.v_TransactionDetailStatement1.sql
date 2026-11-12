SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Transactions].[v_TransactionDetailStatement]
AS
SELECT t.ID ,
    t.TransactionID ,
    t1.Ref ,
    t.DateIs ,
    t.DateOnly ,
    t1.TypeIs AS TransactionType ,
    t1.LinkType ,
    t1.LinkID ,
    t.AccountID ,
    t.CurrencyID ,
    t.BalanceD ,
    t.BalanceLL ,
    t.BalanceEuro ,
    t.CreditD ,
    t.CreditLL ,
    t.CreditEuro ,
    t.DebitD ,
    t.DebitLL ,
    t.DebitEuro ,
    t.StatementIs ,
    t.TypeIs ,
    t.ChequeNumber ,
    t.ChequeDateGet ,
    t.ChequeStopNotificationGet
  FROM Transactions.t_TransactionDetail AS t
  LEFT JOIN Transactions.t_Transaction AS t1 ON t1.ID = t.TransactionID;





GO
