SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarMakeInsert]
  @Name NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @CarModelList NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventModel NVARCHAR(MAX) ,
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

      DECLARE @CarModel TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          Name NVARCHAR(MAX) NOT NULL
        );

      DECLARE @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Cars.t_CarMake
              ( ID, Name, DescriptionIs )
      VALUES  ( @ID, @Name, @DescriptionIs );

      UPDATE  Cars.t_CarMake
      SET     SearchText = ''
      WHERE   ID = @ID;

    END;

    BEGIN --Insert t_CarModel

      SET @CarModelList = [Alls].[f_GetOneAtLess](@CarModelList);

      INSERT  INTO Cars.t_CarModel
              ( Name ,
                CarMakeID ,
                CarMake
              )
      OUTPUT  Inserted.ID ,
              Inserted.Name
              INTO @CarModel ( ID, Name )
      SELECT  s.Name ,
              @ID ,
              @Name
      FROM    Alls.CastArrayToListString(@CarModelList) AS s;

      UPDATE  Cars.t_CarModel
      SET     SearchText = ''
      WHERE   CarMakeID = @ID;

    END;

    BEGIN --Fix t_CarMake

      UPDATE  Cars.t_CarMake
      SET     ModelsCount = ( SELECT  COUNT(*)
                              FROM    Cars.t_CarModel AS s
                              WHERE   ( s.CarMakeID = t_CarMake.ID )
                            )
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
              @EventModel + s.Name ,
              @EventType ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @CarModel AS s;

    END;

    BEGIN --Update t_CarRentalStatistics

      UPDATE  Cars.t_CarRentalStatistics
      SET     Makers += 1 ,
              Models += ( SELECT  COUNT(*)
                          FROM    @CarModel
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
