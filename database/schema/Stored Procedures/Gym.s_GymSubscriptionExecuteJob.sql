SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Gym].[s_GymSubscriptionExecuteJob]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Check i need execute

      IF NOT EXISTS ( SELECT TOP ( 1 )
                              s.ID
                      FROM    Alls.t_LastExecuteJob AS s
                      WHERE   s.Gym_GymSubscription < CONVERT(DATE, GETDATE()) )
      BEGIN

        COMMIT TRANSACTION;

        RETURN 1;

      END;

    END;

    DISABLE TRIGGER Gym.tr_GymSubscription ON Gym.t_GymSubscription;
    DISABLE TRIGGER Gym.tr_GymSubscriptionHistory ON Gym.t_GymSubscriptionHistory;

    BEGIN --Update 

      UPDATE  Gym.t_GymSubscription
      SET     IsActive = CONVERT(BIT, IIF(ToDate >= CONVERT(DATE, GETDATE()), 1, 0)) ,
              IsSync = 0
      WHERE   IsActive = 1;
	  
      UPDATE  Gym.t_GymSubscriptionHistory
      SET     IsActive = CONVERT(BIT, IIF(ToDate >= CONVERT(DATE, GETDATE()), 1, 0)) ,
              IsSync = 0
      WHERE   IsActive = 1;
    
      UPDATE  Gym.t_GymClass
      SET     NumberOfActiveAccounts = Gym.f_GymClassGetNumberOfActiveAccounts(ID);
  
    END;

    ENABLE TRIGGER Gym.tr_GymSubscription ON Gym.t_GymSubscription;
    ENABLE TRIGGER Gym.tr_GymSubscriptionHistory ON Gym.t_GymSubscriptionHistory;

    BEGIN --Execute is done

      UPDATE  Alls.t_LastExecuteJob
      SET     Gym_GymSubscription = GETDATE();

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
