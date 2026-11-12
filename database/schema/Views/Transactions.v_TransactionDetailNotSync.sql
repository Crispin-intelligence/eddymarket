SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Transactions].[v_TransactionDetailNotSync]
AS
SELECT t.ID ,
    t.RowNumber ,
    t.TransactionID ,
    t1.Ref ,
    t1.TypeIs AS TransactionTypeIs ,
    t1.TypeIs + N' ' + t1.RefF AS RefF ,
    t1.LinkType ,
    t1.UserID ,
    t1.UserIs ,
    t.AccountID ,
    t.Account ,
    t2.NumberF ,
    t2.CurrencyTypeIs AS AccountCurrencyTypeIs ,
    t.DateIs ,
    t.DateOnly ,
    t.DateFirstDayInMonth ,
    t.DateFirstDayInYear ,
    t.CurrencyID ,
    t.Currency ,
    t.CurrencyTypeIs ,
    t.ExchangeRate ,
    t.BalanceType ,
    t.Balance ,
    t.BalanceF ,
    t.BalanceD ,
    t.BalanceLL ,
    t.BalanceEuro ,
    t.BalanceAR ,
    t.BalanceEN ,
    t.Credit ,
    t.CreditD ,
    t.CreditLL ,
    t.CreditEuro ,
    t.Debit ,
    t.DebitD ,
    t.DebitLL ,
    t.DebitEuro ,
    t.StatementIs ,
    t.TypeIs ,
    t.ChequeNumber ,
    t.ChequeImage ,
    t.ChequeNote ,
    t.ChequeDateGet ,
    t.ChequeStopNotificationGet ,
    t.NotificationTextAR ,
    t.NotificationTextEN ,
    t.DateCreate ,
    t.IsSync ,
    t.WorkStationID
  FROM Transactions.t_TransactionDetail AS t
  LEFT JOIN Transactions.t_Transaction AS t1 ON t1.ID = t.TransactionID
  LEFT JOIN Company.t_Account AS t2 ON t2.ID = t.AccountID
  WHERE t.IsSync = 0;



GO
