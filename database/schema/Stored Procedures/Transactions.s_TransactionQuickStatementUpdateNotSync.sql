SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Transactions].[s_TransactionQuickStatementUpdateNotSync] @IDAndEvent Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Transactions.tr_TransactionQuickStatement ON Transactions.t_TransactionQuickStatement;

    BEGIN --Update

      UPDATE Transactions.t_TransactionQuickStatement
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDAndEvent AS s
                        WHERE s.ID = t_TransactionQuickStatement.ID );

    END;

    ENABLE TRIGGER Transactions.tr_TransactionQuickStatement ON Transactions.t_TransactionQuickStatement;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, TransactionQuickStatement, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaTransaction, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    COMMIT TRANSACTION;

    SELECT 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT 0;

  END CATCH;

END;



GO
