SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Gym].[s_GymSubscriptionDeletedClassUpdateIsSync] @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    DISABLE TRIGGER Gym.tr_GymSubscriptionDeletedClass ON Gym.t_GymSubscriptionDeletedClass;

    BEGIN --Insert

      UPDATE Gym.t_GymSubscriptionDeletedClass
        SET IsSync = 1
        WHERE ID = @ID;

    END;

    ENABLE TRIGGER Gym.tr_GymSubscriptionDeletedClass ON Gym.t_GymSubscriptionDeletedClass;
		
    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;








GO
