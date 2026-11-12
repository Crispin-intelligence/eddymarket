SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_PurchasingReturnUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Invoices.tr_PurchasingReturn ON Invoices.t_PurchasingReturn;
    DISABLE TRIGGER Invoices.tr_PurchasingReturnDetail ON Invoices.t_PurchasingReturnDetail;
    DISABLE TRIGGER Invoices.tr_PurchasingReturnDetailSerial ON Invoices.t_PurchasingReturnDetailSerial;

    BEGIN --Update

      UPDATE Invoices.t_PurchasingReturn
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_PurchasingReturn.ID );

      UPDATE Invoices.t_PurchasingReturnDetail
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_PurchasingReturnDetail.PurchasingReturnID );

      UPDATE Invoices.t_PurchasingReturnDetailSerial
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_PurchasingReturnDetailSerial.PurchasingReturnID );

    END;

    ENABLE TRIGGER Invoices.tr_PurchasingReturn ON Invoices.t_PurchasingReturn;
    ENABLE TRIGGER Invoices.tr_PurchasingReturnDetail ON Invoices.t_PurchasingReturnDetail;
    ENABLE TRIGGER Invoices.tr_PurchasingReturnDetailSerial ON Invoices.t_PurchasingReturnDetailSerial;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, ReturnPurchased, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
