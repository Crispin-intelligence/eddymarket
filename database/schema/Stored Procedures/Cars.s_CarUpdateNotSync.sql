SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarUpdateNotSync]
  @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Cars.tr_Car ON Cars.t_Car;
    DISABLE TRIGGER Cars.tr_CarOwners ON Cars.t_CarOwners;

    BEGIN --Update

      UPDATE  Cars.t_Car
      SET     IsSync = 0
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDs AS s
                       WHERE  s.ID = t_Car.ID );

      UPDATE  Cars.t_CarOwners
      SET     IsSync = 0
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDs AS s
                       WHERE  s.ID = t_CarOwners.CarID );

    END;

    ENABLE TRIGGER Cars.tr_Car ON Cars.t_Car;
    ENABLE TRIGGER Cars.tr_CarOwners ON Cars.t_CarOwners;
		  
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
