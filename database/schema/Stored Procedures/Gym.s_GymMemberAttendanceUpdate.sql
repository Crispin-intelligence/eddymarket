SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_GymMemberAttendanceUpdate] @DateIs DATETIME ,
  @AccountID UNIQUEIDENTIFIER ,
  @TypeIs TINYINT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
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

      DECLARE @AccountIDOld UNIQUEIDENTIFIER ,
        @DateIsOld DATE ,
        @Account NVARCHAR(MAX) ,
        @AccountNumber NVARCHAR(MAX) ,
        @UserIs NVARCHAR(MAX) ,
        @return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 ) @AccountIDOld = s.AccountID ,
          @DateIsOld = s.DateOnly
        FROM Gym.t_GymMemberAttendance AS s
        WHERE ID = @ID;

      SET @Account = Company.f_AccountGetName(@AccountID);
      SET @AccountNumber = Company.f_AccountGetNumberF(@AccountID);
 
      SET @UserIs = Users.f_UserGetName(@UserID);
		      
    END;

    BEGIN --Insert

      SET @return = 0;

      UPDATE Gym.t_GymMemberAttendance
        SET DateIs = @DateIs ,
            DateOnly = @DateIs ,
            DateMonthly = DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
            DateYearly = DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
            AccountID = @AccountID ,
            Account = @Account ,
            AccountNumber = @AccountNumber ,
            TypeIs = @TypeIs ,
            TypeIsAR = Gym.f_GymMemberAttendanceTypeIsARConvert(@TypeIs) ,
            TypeIsEN = Gym.f_GymMemberAttendanceTypeIsENConvert(@TypeIs) ,
            DescriptionIs = @DescriptionIs
        WHERE ID = @ID;

    END;

    BEGIN --Insert Event

      SET @return = -1;

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
            @Event + @Account ,
            @EventType ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;
  
    BEGIN --Fix t_Account GymMemberAttendance

      UPDATE Company.t_Account
        SET GymMemberAttendanceC -= 1 ,
            GymMemberAttendanceLast = [Gym].f_GymMemberAttendanceGetLastByAccountID(ID)
        WHERE ID = @AccountIDOld;

      UPDATE Company.t_Account
        SET GymMemberAttendanceC += 1 ,
            GymMemberAttendanceLast = [Gym].f_GymMemberAttendanceGetLastByAccountID(ID)
        WHERE ID = @AccountID;

    END;

    BEGIN --Fix t_GymActiveVSAttendance

      EXECUTE Gym.s_GymActiveVSAttendanceMerge @DateIsOld, @DateIsOld, 0, 0; 
      EXECUTE Gym.s_GymActiveVSAttendanceMerge @DateIs, @DateIs, 0, 1; 
	  
    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @return;

  END CATCH;

END;

GO
