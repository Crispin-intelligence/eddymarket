SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Transactions].[s_TransactionQuickStatementUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Transactions.tr_TransactionQuickStatement ON Transactions.t_TransactionQuickStatement;

    BEGIN --Update

      UPDATE Transactions.t_TransactionQuickStatement
        SET IsSync = 0;

    END;

    ENABLE TRIGGER Transactions.tr_TransactionQuickStatement ON Transactions.t_TransactionQuickStatement;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, TransactionQuickStatement, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaTransaction, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN 0;

  END CATCH;

END;



GO
