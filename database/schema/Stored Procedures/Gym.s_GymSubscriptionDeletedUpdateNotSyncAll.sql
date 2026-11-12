SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [Gym].[s_GymSubscriptionDeletedUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Gym.tr_GymSubscriptionDeleted ON Gym.t_GymSubscriptionDeleted;

    BEGIN --Update

      UPDATE Gym.t_GymSubscriptionDeleted
        SET IsSync = 0;

    END;

    ENABLE TRIGGER Gym.tr_GymSubscriptionDeleted ON Gym.t_GymSubscriptionDeleted;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, GymSubscription, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
