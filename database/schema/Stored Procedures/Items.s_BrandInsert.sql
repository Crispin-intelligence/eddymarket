SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_BrandInsert]
  @Name NVARCHAR(MAX) ,
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

      INSERT  INTO Items.t_Brand
              ( ID, Name, DescriptionIs )
      VALUES  ( @ID, @Name, @DescriptionIs );


      UPDATE  Items.t_Brand
      SET     SearchText = Items.f_BrandSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_BrandMoving
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

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;



GO
