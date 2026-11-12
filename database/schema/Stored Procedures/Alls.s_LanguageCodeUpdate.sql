SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_LanguageCodeUpdate]
  @Name NVARCHAR(MAX) ,
  @ShortCode NVARCHAR(MAX) ,
  @FullCode NVARCHAR(MAX) ,
  @ImageIs IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
  @IsSyncImage BIT ,
  @InternationalDialingPrefix NVARCHAR(MAX) ,
  @CountryCallingCode NVARCHAR(MAX) ,
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

      DECLARE @Return INT ,
        @NameOld NVARCHAR(450);

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Alls.t_LanguageCode AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Alls.t_LanguageCode
      SET     Name = @Name ,
              ShortCode = @ShortCode ,
              FullCode = @FullCode ,
              ImageIs = @ImageIs ,
              ImagePath = @ImagePath ,
              IsSyncImage = @IsSyncImage ,
              InternationalDialingPrefix = @InternationalDialingPrefix ,
              CountryCallingCode = @CountryCallingCode ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

      UPDATE  Alls.t_LanguageCode
      SET     SearchText = Alls.f_LanguageCodeSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Alls.t_LanguageCodeMoving
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
		
      BEGIN --Fix BookPhone

        UPDATE  Company.t_BookPhone
        SET     LanguageCode = @NameOld
        WHERE   LanguageCodeID = @ID;

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
