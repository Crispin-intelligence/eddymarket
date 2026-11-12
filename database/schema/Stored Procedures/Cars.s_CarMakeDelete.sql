SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarMakeDelete]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ModelEvent NVARCHAR(MAX) ,
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

      DECLARE @Models TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          Name NVARCHAR(MAX) NOT NULL
        );

      DECLARE @Return INT = 0;

    END;

    BEGIN --Set

      INSERT  INTO @Models
              ( ID ,
                Name
              )
      SELECT  s.ID ,
              s.Name
      FROM    Cars.t_CarModel AS s
      WHERE   s.CarMakeID = @ID;

    END;

    BEGIN --Delete

      DELETE  FROM Cars.t_CarModel
      WHERE   CarMakeID = @ID;

      DELETE  FROM Cars.t_CarMake
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarMakeMoving
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
    
      INSERT  INTO Cars.t_CarModelMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      SELECT  @UserID ,
              s.ID ,
              @ModelEvent + ': ' + s.Name ,
              @EventType ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @Models AS s;

    END;

    BEGIN --Update t_CarRentalStatistics

      UPDATE  Cars.t_CarRentalStatistics
      SET     Makers -= 1 ,
              Models -= ( SELECT  COUNT(*)
                          FROM    @Models
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
