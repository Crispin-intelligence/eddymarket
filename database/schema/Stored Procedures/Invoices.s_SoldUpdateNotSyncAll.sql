SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_SoldUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Invoices.tr_Sold ON Invoices.t_Sold;
    DISABLE TRIGGER Invoices.tr_SoldDetail ON Invoices.t_SoldDetail;
    DISABLE TRIGGER Invoices.tr_SoldDetailSerial ON Invoices.t_SoldDetailSerial;
    DISABLE TRIGGER Invoices.tr_SoldProfitPartner ON Invoices.t_SoldProfitPartner;
    DISABLE TRIGGER Invoices.tr_SoldDetailProfitPartner ON Invoices.t_SoldDetailProfitPartner;

    BEGIN --Update

      UPDATE  Invoices.t_Sold
      SET     IsSync = 0;

      UPDATE  Invoices.t_SoldDetail
      SET     IsSync = 0;

      UPDATE  Invoices.t_SoldDetailSerial
      SET     IsSync = 0;

      UPDATE  Invoices.t_SoldProfitPartner
      SET     IsSync = 0;

      UPDATE  Invoices.t_SoldDetailProfitPartner
      SET     IsSync = 0;

    END;

    ENABLE TRIGGER Invoices.tr_Sold ON Invoices.t_Sold;
    ENABLE TRIGGER Invoices.tr_SoldDetail ON Invoices.t_SoldDetail;
    ENABLE TRIGGER Invoices.tr_SoldDetailSerial ON Invoices.t_SoldDetailSerial;
    ENABLE TRIGGER Invoices.tr_SoldProfitPartner ON Invoices.t_SoldProfitPartner;
    ENABLE TRIGGER Invoices.tr_SoldDetailProfitPartner ON Invoices.t_SoldDetailProfitPartner;
		  
    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, Sell, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));
     
      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, SoldProfitPartner, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));
	 
      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, SoldDetailProfitPartner, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
