SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Gym].[s_GymSubscriptionClassUpdateIsSync] @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    DISABLE TRIGGER Gym.tr_GymSubscriptionClass ON Gym.t_GymSubscriptionClass;

    BEGIN --Insert

      UPDATE Gym.t_GymSubscriptionClass
        SET IsSync = 1
        WHERE ID = @ID;

    END;

    ENABLE TRIGGER Gym.tr_GymSubscriptionClass ON Gym.t_GymSubscriptionClass;
		
    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;








GO
