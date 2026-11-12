SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Transactions].[v_TransactionQuickStatementList]
AS
SELECT t.ID ,
    t.Name ,
    t.ShortcutText ,
    t.SectionID ,
    t.DateCreate ,
    t.CreateBy ,
    t.IsSync
  FROM Transactions.t_TransactionQuickStatement AS t;



GO
