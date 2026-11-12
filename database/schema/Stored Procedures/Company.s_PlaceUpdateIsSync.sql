SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_PlaceUpdateIsSync]
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

    DISABLE TRIGGER Company.tr_Place ON Company.t_Place;

    BEGIN --Insert

      UPDATE  Company.t_Place
      SET     IsSync = @IsSync
      WHERE   ID = @ID;

    END;

    ENABLE TRIGGER Company.tr_Place ON Company.t_Place;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_PlaceMoving
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

    ENABLE TRIGGER Company.tr_Place ON Company.t_Place;

    RETURN @Return;

  END CATCH;

END;




GO
