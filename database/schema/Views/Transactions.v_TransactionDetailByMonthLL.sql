SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Transactions].[v_TransactionDetailByMonthLL]
AS

SELECT t.ID,
       t.AccountID,
       t.Account,
       t1.NumberF,
       t1.BalanceLL AS Balance,
       t.DateOnly,
       t.BalanceLL AS Total,
       t.CreditLL AS Credit,
       t.DebitLL AS Debit
FROM Transactions.t_TransactionDetailByMonth AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.AccountID;



GO
