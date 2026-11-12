SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Transactions].[v_TransactionDetailMinDate]
AS
SELECT DISTINCT
       t.AccountID,
       MIN(t.DateOnly) AS DateOnly
FROM Transactions.t_TransactionDetail AS t
GROUP BY t.AccountID;




GO
