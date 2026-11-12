SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Gym].[s_GymMemberAttendanceInsert] @DateIs DATETIME ,
  @AccountID UNIQUEIDENTIFIER ,
  @TypeIs TINYINT ,
  @IntegrationAccessLastIDSaved BIGINT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
  BEGIN TRY

    BEGIN TRANSACTION;

    IF EXISTS ( SELECT TOP ( 1 ) s.ID
                  FROM Gym.t_GymMemberAttendance AS s
                  WHERE s.AccountID = @AccountID AND s.DateOnly = CONVERT(DATE, @DateIs) )
    BEGIN

      IF @TypeIs = 1 AND @IntegrationAccessLastIDSaved >= 1
      BEGIN --Update t_SettingPC

        UPDATE Users.t_SettingPC
          SET GymSubscriptionSettingUIIntegrationAccessLastIDSaved = @IntegrationAccessLastIDSaved;

      END;

      SET @ID = '00000000-0000-0000-0000-000000000000';

      COMMIT TRANSACTION;

      RETURN 1;

    END;

    BEGIN --Declare

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @Account NVARCHAR(MAX) ,
        @AccountNumber NVARCHAR(MAX) ,
        @UserIs NVARCHAR(MAX) ,
        @return INT;

    END;

    BEGIN --Set info
	
      SET @Account = Company.f_AccountGetName(@AccountID);
      SET @AccountNumber = Company.f_AccountGetNumberF(@AccountID);
 
      SET @UserIs = Users.f_UserGetName(@UserID);
		      
    END;

    BEGIN --Insert

      SET @return = 0;

      INSERT INTO Gym.t_GymMemberAttendance
          ( DateIs ,
            DateOnly ,
            DateMonthly ,
            DateYearly ,
            AccountID ,
            Account ,
            AccountNumber ,
            TypeIs ,
            TypeIsAR ,
            TypeIsEN ,
            DescriptionIs
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @DateIs ,
            @DateIs ,
            DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
            DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
            @AccountID ,
            @Account ,
            @AccountNumber ,
            @TypeIs ,
            Gym.f_GymMemberAttendanceTypeIsARConvert(@TypeIs) ,
            Gym.f_GymMemberAttendanceTypeIsENConvert(@TypeIs) ,
            @DescriptionIs
          );

      SET @ID = ( SELECT TOP ( 1 ) s.ID
                    FROM @IDs AS s
                    ORDER BY s.ID
                );

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
        SET GymMemberAttendanceC += 1 ,
            GymMemberAttendanceLast = [Gym].f_GymMemberAttendanceGetLastByAccountID(ID)
        WHERE ID = @AccountID;

    END;

    BEGIN --Fix t_GymActiveVSAttendance

      EXECUTE Gym.s_GymActiveVSAttendanceMerge @DateIs, @DateIs, 0, 1; 
	  
    END;

    IF @TypeIs = 1 AND @IntegrationAccessLastIDSaved >= 1
    BEGIN --Update t_SettingPC

      UPDATE Users.t_SettingPC
        SET GymSubscriptionSettingUIIntegrationAccessLastIDSaved = @IntegrationAccessLastIDSaved;

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
