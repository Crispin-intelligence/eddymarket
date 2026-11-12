SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [Cars].[s_CarRentalStatisticsUpdateIsSync]
  @IsSync BIT ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
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

    DISABLE TRIGGER Cars.tr_CarRentalStatistics ON Cars.t_CarRentalStatistics;

    BEGIN --Insert

      UPDATE  Cars.t_CarRentalStatistics
      SET     IsSync = @IsSync
      WHERE   ID = @ID;

    END;

    ENABLE TRIGGER Cars.tr_CarRentalStatistics ON Cars.t_CarRentalStatistics;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarRentalStatisticsMoving
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
                7 ,
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
