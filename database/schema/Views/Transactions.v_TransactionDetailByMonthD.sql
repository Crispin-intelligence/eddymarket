SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Transactions].[v_TransactionDetailByMonthD]
AS
SELECT t.ID,
       t.AccountID,
       t.Account,
       t1.NumberF,
       t1.BalanceD AS Balance,
       t.DateOnly,
       t.BalanceD AS Total,
       t.CreditD AS Credit,
       t.DebitD AS Debit
FROM Transactions.t_TransactionDetailByMonth AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.AccountID;




GO
