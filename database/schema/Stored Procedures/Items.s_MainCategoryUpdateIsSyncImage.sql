SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_MainCategoryUpdateIsSyncImage] @IsSyncImage BIT ,
  @ImagePath NVARCHAR(MAX) ,
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

    DISABLE TRIGGER Items.tr_MainCategory ON Items.t_MainCategory;

    BEGIN --Insert

      SET @Return = 0;

      UPDATE Items.t_MainCategory
        SET IsSyncImage = @IsSyncImage ,
            ImagePath = @ImagePath
        WHERE ID = @ID;

    END;

    ENABLE TRIGGER Items.tr_MainCategory ON Items.t_MainCategory;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Items.t_MainCategoryMoving
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
            8 ,
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
