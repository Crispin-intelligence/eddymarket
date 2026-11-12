SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Gym].[s_GymSubscriptionDeletedUpdateIsSync] @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    DISABLE TRIGGER Gym.tr_GymSubscriptionDeleted ON Gym.t_GymSubscriptionDeleted;

    BEGIN --Insert

      UPDATE Gym.t_GymSubscriptionDeleted
        SET IsSync = 1
        WHERE ID = @ID;

    END;

    ENABLE TRIGGER Gym.tr_GymSubscriptionDeleted ON Gym.t_GymSubscriptionDeleted;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Gym.t_GymSubscriptionMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        VALUES
          ( @UserID ,
            @ID ,
            @Event ,
            7 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;










GO
