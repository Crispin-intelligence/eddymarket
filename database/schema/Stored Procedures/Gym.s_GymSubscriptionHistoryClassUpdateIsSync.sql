SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Gym].[s_GymSubscriptionHistoryClassUpdateIsSync] @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    DISABLE TRIGGER Gym.tr_GymSubscriptionHistoryClass ON Gym.t_GymSubscriptionHistoryClass;

    BEGIN --Insert

      UPDATE Gym.t_GymSubscriptionHistoryClass
        SET IsSync = 1
        WHERE ID = @ID;

    END;

    ENABLE TRIGGER Gym.tr_GymSubscriptionHistoryClass ON Gym.t_GymSubscriptionHistoryClass;
		
    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;








GO
