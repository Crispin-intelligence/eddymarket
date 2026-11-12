SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Transactions].[v_TransactionDetailBase]
AS
SELECT t.ID,
       t.TransactionID,
       t.AccountID
FROM Transactions.t_TransactionDetail AS t;

GO
