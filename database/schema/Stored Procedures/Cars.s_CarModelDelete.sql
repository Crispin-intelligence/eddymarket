SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarModelDelete]
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

      DECLARE @CarMakeID UNIQUEIDENTIFIER ,
        @ModelCount INT ,
        @Return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @CarMakeID = s.CarMakeID
      FROM    Cars.t_CarModel AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Delete

      SET @Return = 0;

      DELETE  FROM Cars.t_CarModel
      WHERE   ID = @ID;

    END;

    BEGIN --Delete t_CarModel

      SELECT  @ModelCount = COUNT(s.ID)
      FROM    Cars.t_CarModel AS s
      WHERE   s.CarMakeID = @CarMakeID;

      IF @ModelCount = 0
      BEGIN
                       
        DELETE  FROM Cars.t_CarMake
        WHERE   ID = @CarMakeID;

      END;

    END;

    BEGIN --Fix t_CarMake

      UPDATE  Cars.t_CarMake
      SET     ModelsCount -= 1
      WHERE   ID = @CarMakeID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarModelMoving
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
      SET     Makers -= @ModelCount ,
              Models -= 1;

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
