SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarRentalUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Cars.tr_CarRental ON Cars.t_CarRental;

    BEGIN --Update

      UPDATE  Cars.t_CarRental
      SET     IsSync = 0;
  
      UPDATE  Cars.t_CarRentalDriver
      SET     IsSync = 0;

      UPDATE  Cars.t_CarRentalOwner
      SET     IsSync = 0;

    END;

    ENABLE TRIGGER Cars.tr_CarRental ON Cars.t_CarRental;
		  
    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, CarRental, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
