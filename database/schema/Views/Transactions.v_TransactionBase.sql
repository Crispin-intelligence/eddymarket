SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Transactions].[v_TransactionBase]
AS
SELECT t.ID ,
    t.Ref ,
    t.RefF
  FROM Transactions.t_Transaction AS t;


GO
