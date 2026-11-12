SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_SubscriptionTypeUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Gym.tr_SubscriptionType ON Gym.t_SubscriptionType;

    BEGIN --Update

      UPDATE Gym.t_SubscriptionType
        SET IsSync = 0;

    END;

    ENABLE TRIGGER Gym.tr_SubscriptionType ON Gym.t_SubscriptionType;
   
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, SubscriptionType, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
