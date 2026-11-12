SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_GymMemberAttendanceRebuildingStatistics] @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    DISABLE TRIGGER Gym.tr_GymMemberAttendance ON Gym.t_GymMemberAttendance;

    BEGIN --Rebuild statistics

      SET @Return = 0;
  
      UPDATE Gym.t_GymMemberAttendance
        SET Account = Company.f_AccountGetName(AccountID) ,
            IsSync = 0;

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
            '00000000-0000-0000-0000-000000000000' ,
            @Event ,
            6 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, GymMemberAttendance, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    ENABLE TRIGGER Gym.tr_GymMemberAttendance ON Gym.t_GymMemberAttendance;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;






GO
