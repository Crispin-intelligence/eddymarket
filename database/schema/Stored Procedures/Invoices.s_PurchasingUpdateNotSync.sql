SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_PurchasingUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Invoices.tr_Purchasing ON Invoices.t_Purchasing;
    DISABLE TRIGGER Invoices.tr_PurchasingDetail ON Invoices.t_PurchasingDetail;
    DISABLE TRIGGER Invoices.tr_PurchasingDetailSerial ON Invoices.t_PurchasingDetailSerial;

    BEGIN --Update

      UPDATE Invoices.t_Purchasing
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_Purchasing.ID );

      UPDATE Invoices.t_PurchasingDetail
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_PurchasingDetail.PurchasingID );

      UPDATE Invoices.t_PurchasingDetailSerial
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_PurchasingDetailSerial.PurchasingID );

    END;

    ENABLE TRIGGER Invoices.tr_Purchasing ON Invoices.t_Purchasing;
    ENABLE TRIGGER Invoices.tr_PurchasingDetail ON Invoices.t_PurchasingDetail;
    ENABLE TRIGGER Invoices.tr_PurchasingDetailSerial ON Invoices.t_PurchasingDetailSerial;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Purchase, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
