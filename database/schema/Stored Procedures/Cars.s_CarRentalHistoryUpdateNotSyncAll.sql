SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarRentalHistoryUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Cars.tr_CarRentalHistory ON Cars.t_CarRentalHistory;

    BEGIN --Update

      UPDATE  Cars.t_CarRentalHistory
      SET     IsSync = 0;
  
      UPDATE  Cars.t_CarRentalHistoryDriver
      SET     IsSync = 0;

      UPDATE  Cars.t_CarRentalHistoryOwner
      SET     IsSync = 0;

    END;

    ENABLE TRIGGER Cars.tr_CarRentalHistory ON Cars.t_CarRentalHistory;
		  
    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, CarRentalHistory, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
