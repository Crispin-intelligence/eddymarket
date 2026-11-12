SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [Gym].[s_GymClassUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Gym.tr_GymClass ON Gym.t_GymClass;

    BEGIN --Update

      UPDATE Gym.t_GymClass
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_GymClass.ID );

    END;

    ENABLE TRIGGER Gym.tr_GymClass ON Gym.t_GymClass;
   
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, GymClass, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
