SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_MainCategoryInsert]
  @Name NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @ImageIs IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
  @Printer NVARCHAR(MAX) ,
  @SubCategoryList NVARCHAR(MAX) ,
  @SubCategoryEvent NVARCHAR(MAX) ,
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

      DECLARE @SubCategory TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          Name NVARCHAR(MAX) NOT NULL
        );

      DECLARE @OrderBy INT ,
        @Return INT;

    END;

    BEGIN --Set Info
    
      SELECT  @OrderBy = ISNULL(SUM(s.OrderBy), 0) + 1
      FROM    Items.t_MainCategory AS s;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Items.t_MainCategory
              ( ID ,
                Name ,
                DescriptionIs ,
                ImageIs ,
                ImagePath ,
                IsSyncImage ,
                Printer ,
                OrderBy
              )
      VALUES  ( @ID ,
                @Name ,
                @DescriptionIs ,
                @ImageIs ,
                @ImagePath ,
                IIF(@ImagePath = N'', 0, 1) ,
                @Printer ,
                @OrderBy
              );

      UPDATE  Items.t_MainCategory
      SET     SearchText = Items.f_MainCategorySearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert SubCategory

      SET @SubCategoryList = [Alls].[f_GetOneAtLess](@SubCategoryList);

      INSERT  INTO Items.t_SubCategory
              ( Name ,
                MainCategoryID ,
                MainCategory
              )
      OUTPUT  Inserted.ID ,
              Inserted.Name
              INTO @SubCategory ( ID, Name )
      SELECT  s.Name ,
              @ID ,
              @Name
      FROM    Alls.CastArrayToListString(@SubCategoryList) AS s;

      UPDATE  Items.t_SubCategory
      SET     SearchText = Items.f_SubCategorySearchTextGet(ID)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @SubCategory AS s
                       WHERE  s.ID = t_SubCategory.ID );

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

    BEGIN --Insert event SubCategory

      INSERT  INTO Items.t_SubCategoryMoving
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
              @SubCategoryEvent + s.Name ,
              @EventType ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @SubCategory AS s;

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
