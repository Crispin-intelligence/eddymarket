SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_MainCategoryUpdate]
  @Name NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @ImageIs IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
  @Printer NVARCHAR(MAX) ,
  @IsSyncImage BIT ,
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

      DECLARE @Return INT ,
        @NameOld NVARCHAR(450);

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Items.t_MainCategory AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Items.t_MainCategory
      SET     Name = @Name ,
              DescriptionIs = @DescriptionIs ,
              ImageIs = @ImageIs ,
              ImagePath = @ImagePath ,
              IsSyncImage = @IsSyncImage ,
              Printer = @Printer
      WHERE   ID = @ID;

      UPDATE  Items.t_MainCategory
      SET     SearchText = Items.f_MainCategorySearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_MainCategoryMoving
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

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix

      BEGIN --Fix SubCategory

        UPDATE  Items.t_SubCategory
        SET     MainCategory = @Name
        WHERE   MainCategoryID = @ID;

      END;

      BEGIN --Fix ItemShared

        UPDATE  Items.t_ItemShared
        SET     MainCategory = @Name
        WHERE   MainCategoryID = @ID;

      END;

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
