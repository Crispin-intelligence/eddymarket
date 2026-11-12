SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Company].[s_DoctorUpdateImage]
  @ImageIs IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
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

      DECLARE @Return INT;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Company.t_Doctor
      SET     ImageIs = @ImageIs ,
              ImagePath = @ImagePath ,
              IsSyncImage = IIF(@ImagePath = '', 0, 1)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_DoctorMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @ID ,
                @Event ,
                @EventType ,
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
