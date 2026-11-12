SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarOwnersProfileDelete]
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
    BEGIN TRANSACTION CarOwnersProfileDelete;

    BEGIN --Declare

      DECLARE @Return INT = -3;

    END;

    BEGIN --Delete account

      DELETE  FROM Company.t_Account
      WHERE   SectionID = 179
              AND LinkWithID = @ID;

    END;

    BEGIN --Delete

      SET @Return = 0;

      DELETE  FROM Cars.t_CarOwnersProfile
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarOwnersProfileMoving
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

    BEGIN --Update t_CarRentalStatistics

      UPDATE  Cars.t_CarRentalStatistics
      SET     Owners -= 1;

    END;

    COMMIT TRANSACTION CarOwnersProfileDelete;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK TRANSACTION CarOwnersProfileDelete;

    RETURN @Return;

  END CATCH;

END;










GO
