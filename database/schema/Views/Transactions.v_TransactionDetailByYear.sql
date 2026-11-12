SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Transactions].[v_TransactionDetailByYear]
AS
SELECT t.ID,
       t.AccountID,
       t.Account,
       t.DateOnly,
       t.BalanceD,
       t.BalanceLL,
       t.BalanceEuro,
       t.CreditD,
       t.CreditLL,
       t.CreditEuro,
       t.DebitD,
       t.DebitLL,
       t.DebitEuro,
       t.DateCreate
FROM Transactions.t_TransactionDetailByYear AS t;


GO
