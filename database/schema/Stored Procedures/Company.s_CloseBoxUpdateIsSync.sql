SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_CloseBoxUpdateIsSync] @IsSync BIT ,
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

    DISABLE TRIGGER Company.tr_CloseBox ON Company.t_CloseBox;
    DISABLE TRIGGER Company.tr_CloseBoxDetail ON Company.t_CloseBoxDetail;

    BEGIN --Insert

      UPDATE Company.t_CloseBox
        SET IsSync = @IsSync
        WHERE ID = @ID;

      IF @IsSync = 0
      BEGIN
                   
        UPDATE Company.t_CloseBoxDetail
          SET IsSync = @IsSync
          WHERE CloseBoxID = @ID;

      END;

    END;

    ENABLE TRIGGER Company.tr_CloseBox ON Company.t_CloseBox;
    ENABLE TRIGGER Company.tr_CloseBoxDetail ON Company.t_CloseBoxDetail;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Company.t_CloseBoxMoving
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
