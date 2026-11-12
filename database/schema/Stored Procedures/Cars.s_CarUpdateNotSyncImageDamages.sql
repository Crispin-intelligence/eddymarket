SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarUpdateNotSyncImageDamages]
  @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Cars.tr_Car ON Cars.t_Car;

    BEGIN --Update

      UPDATE  Cars.t_Car
      SET     IsSyncDamagesImage = 0
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDs AS s
                       WHERE  s.ID = t_Car.ID );

    END;

    ENABLE TRIGGER Cars.tr_Car ON Cars.t_Car;
  
    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, Car, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    COMMIT TRANSACTION;

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  0;

  END CATCH;

END;










GO
