SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_SoldReturnUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Invoices.tr_SoldReturn ON Invoices.t_SoldReturn;
    DISABLE TRIGGER Invoices.tr_SoldReturnDetail ON Invoices.t_SoldReturnDetail;
    DISABLE TRIGGER Invoices.tr_SoldReturnDetailSerial ON Invoices.t_SoldReturnDetailSerial;

    BEGIN --Update

      UPDATE Invoices.t_SoldReturn
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_SoldReturn.ID );

      UPDATE Invoices.t_SoldReturnDetail
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_SoldReturnDetail.SoldReturnID );

      UPDATE Invoices.t_SoldReturnDetailSerial
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_SoldReturnDetailSerial.SoldReturnID );

    END;

    ENABLE TRIGGER Invoices.tr_SoldReturn ON Invoices.t_SoldReturn;
    ENABLE TRIGGER Invoices.tr_SoldReturnDetail ON Invoices.t_SoldReturnDetail;
    ENABLE TRIGGER Invoices.tr_SoldReturnDetailSerial ON Invoices.t_SoldReturnDetailSerial;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, ReturnSold, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
