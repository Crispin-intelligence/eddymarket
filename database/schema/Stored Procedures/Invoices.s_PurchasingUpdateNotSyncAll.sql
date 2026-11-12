SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_PurchasingUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Invoices.tr_Purchasing ON Invoices.t_Purchasing;
    DISABLE TRIGGER Invoices.tr_PurchasingDetail ON Invoices.t_PurchasingDetail;
    DISABLE TRIGGER Invoices.tr_PurchasingDetailSerial ON Invoices.t_PurchasingDetailSerial;

    BEGIN --Update

      UPDATE Invoices.t_Purchasing
        SET IsSync = 0;

      UPDATE Invoices.t_PurchasingDetail
        SET IsSync = 0;

      UPDATE Invoices.t_PurchasingDetailSerial
        SET IsSync = 0;

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

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN 0;

  END CATCH;

END;






GO
