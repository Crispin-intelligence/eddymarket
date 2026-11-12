SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Transactions].[v_TransactionDetailByDayEuro]
AS
SELECT t.ID,
       t.AccountID,
       t.Account,
       t1.NumberF,
       t1.BalanceEuro AS Balance,
       t.DateOnly,
       t.BalanceEuro AS Total,
       t.CreditEuro AS Credit,
       t.DebitEuro AS Debit
FROM Transactions.t_TransactionDetailByDay AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.AccountID;




GO
