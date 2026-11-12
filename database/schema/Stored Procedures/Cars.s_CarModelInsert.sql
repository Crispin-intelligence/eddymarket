SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarModelInsert]
  @Name NVARCHAR(MAX) ,
  @CarMakeID UNIQUEIDENTIFIER ,
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
	
      DECLARE @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Cars.t_CarModel
              ( ID ,
                Name ,
                CarMakeID ,
                CarMake ,
                DescriptionIs
              )
      VALUES  ( @ID ,
                @Name ,
                @CarMakeID ,
                Cars.f_CarMakeGetName(@CarMakeID) ,
                @DescriptionIs
              );

      UPDATE  Cars.t_CarModel
      SET     SearchText = ''
      WHERE   ID = @ID;

    END;

    BEGIN --Fix t_CarMake

      UPDATE  Cars.t_CarMake
      SET     ModelsCount += 1
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
      SET     Models += 1;

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
