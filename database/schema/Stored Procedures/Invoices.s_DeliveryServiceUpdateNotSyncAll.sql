SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_DeliveryServiceUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Invoices.tr_DeliveryService ON Invoices.t_DeliveryService;

    BEGIN --Update

      UPDATE Invoices.t_DeliveryService
        SET IsSync = 0;

    END;

    ENABLE TRIGGER Invoices.tr_DeliveryService ON Invoices.t_DeliveryService;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, DeliveryService, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
