SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_LanguageCodeInsert]
  @Name NVARCHAR(MAX) ,
  @ShortCode NVARCHAR(MAX) ,
  @FullCode NVARCHAR(MAX) ,
  @ImageIs IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
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

      DECLARE @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Alls.t_LanguageCode
              ( ID ,
                Name ,
                ShortCode ,
                FullCode ,
                ImageIs ,
                ImagePath ,
                IsSyncImage ,
                InternationalDialingPrefix ,
                CountryCallingCode ,
                DescriptionIs
              )
      VALUES  ( @ID ,
                @Name ,
                @ShortCode ,
                @FullCode ,
                @ImageIs ,
                @ImagePath ,
                IIF(@ImagePath = N'', 0, 1) ,
                @InternationalDialingPrefix ,
                @CountryCallingCode ,
                @DescriptionIs
              );

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

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;


GO
