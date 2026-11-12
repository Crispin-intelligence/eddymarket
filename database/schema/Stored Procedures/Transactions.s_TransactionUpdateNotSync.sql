SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Transactions].[s_TransactionUpdateNotSync] @IDAndEvent Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Transactions.tr_Transaction ON Transactions.t_Transaction;
    DISABLE TRIGGER Transactions.tr_TransactionDetail ON Transactions.t_TransactionDetail;

    BEGIN --Update

      UPDATE Transactions.t_TransactionDetail
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDAndEvent AS s
                        WHERE s.ID = t_TransactionDetail.TransactionID );

      UPDATE Transactions.t_Transaction
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDAndEvent AS s
                        WHERE s.ID = t_Transaction.ID );

    END;

    ENABLE TRIGGER Transactions.tr_Transaction ON Transactions.t_Transaction;
    ENABLE TRIGGER Transactions.tr_TransactionDetail ON Transactions.t_TransactionDetail;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, TransactionIs, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
