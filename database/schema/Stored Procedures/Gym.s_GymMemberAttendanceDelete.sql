SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Gym].[s_GymMemberAttendanceDelete] @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @DateIs DATE ,
        @ToDate DATE ,
        @AccountID UNIQUEIDENTIFIER ,
        @Return INT;
 
    END;

    BEGIN --Set info
	    
      SELECT TOP ( 1 ) @DateIs = s.DateIs ,
          @ToDate = s.DateIs ,
          @AccountID = s.AccountID
        FROM Gym.t_GymMemberAttendance AS s
        WHERE s.ID = @ID;

    END;

    BEGIN --Delete

      DELETE FROM Gym.t_GymMemberAttendance
        WHERE ID = @ID;

    END;

    BEGIN --Fix t_GymActiveVSAttendance

      EXECUTE Gym.s_GymActiveVSAttendanceMerge @DateIs, @ToDate, 0, 0; 
	  
    END;
			
    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Gym.t_GymMemberAttendanceMoving
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
            @EventType ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    BEGIN --Fix t_Account GymMemberAttendance

      UPDATE Company.t_Account
        SET GymMemberAttendanceC = [Gym].f_GymMemberAttendanceGetCountByAccountID(ID) ,
            GymMemberAttendanceLast = [Gym].f_GymMemberAttendanceGetLastByAccountID(ID)
        WHERE ID = @AccountID;
		  
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
