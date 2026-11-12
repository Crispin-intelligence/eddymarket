SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Transactions].[v_TransactionQuickStatement]
AS
SELECT t.ID ,
       t.Name ,
       t.ShortcutText ,
       t.SectionID ,
       t.DateCreate ,
       t.CreateByID ,
       t.CreateBy ,
       t.IsSync
FROM Transactions.t_TransactionQuickStatement AS t;


GO
