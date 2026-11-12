SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Transactions].[v_TransactionDetailListOnlyCarRental]
AS
SELECT  t.ID ,
        t.TransactionID ,
        t1.Ref ,
        t1.RefF ,
        t1.TypeIs AS TransactionType,
        t1.DateIs ,
        t1.UserID ,
        t1.UserIs ,
        t1.LinkTypeSub ,
        t1.LinkID ,
        t1.SubLinkID ,
        t1.DateCreate ,
        t1.IsSync ,
        t.AccountID ,
        t2.Name AS Account ,
        t2.BalanceF AS AccountBalanceF ,
        t2.BalanceD AS AccountBalanceD ,
        t2.NumberF ,
        t.Balance ,
        t.BalanceF ,
        t.BalanceD ,
        t.BalanceLL ,
        t.BalanceEuro ,
        t.StatementIs ,
        t.TypeIs
FROM    Transactions.t_TransactionDetail AS t
INNER  JOIN Transactions.t_Transaction AS t1 ON t1.ID = t.TransactionID
INNER  JOIN Company.t_Account AS t2 ON t2.ID = t.AccountID
WHERE   t1.LinkType = 185;



GO
