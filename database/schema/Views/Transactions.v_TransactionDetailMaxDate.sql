SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Transactions].[v_TransactionDetailMaxDate]
AS
SELECT DISTINCT
       t.AccountID,
       MAX(t.DateOnly) AS DateOnly
FROM Transactions.t_TransactionDetail AS t
GROUP BY t.AccountID;




GO
