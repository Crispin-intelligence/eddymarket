SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_BankInsert]
  @Name NVARCHAR(450) ,
  @Phones Company.td_BookPhone READONLY ,
  @SocialMedia Company.dt_SocialMedia READONLY ,
  @StatesID UNIQUEIDENTIFIER ,
  @RegionID UNIQUEIDENTIFIER ,
  @StreetID UNIQUEIDENTIFIER ,
  @BuildingID UNIQUEIDENTIFIER ,
  @FloorID UNIQUEIDENTIFIER ,
  @PostalCodeID UNIQUEIDENTIFIER ,
  @AddressNote NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @AccountCurrencyID UNIQUEIDENTIFIER ,
  @EventBase NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER ,
  @AccountID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Company.t_Bank
              (ID, Name ,
                StatesID ,
                RegionID ,
                StreetID ,
                BuildingID ,
                FloorID ,
                PostalCodeID ,
                AddressNote ,
                DescriptionIs
              )
      VALUES  (@ID, @Name ,
                @StatesID ,
                @RegionID ,
                @StreetID ,
                @BuildingID ,
                @FloorID ,
                @PostalCodeID ,
                @AddressNote ,
                @DescriptionIs
              );

    END;

    BEGIN --Insert account

      SET @Return = -5;

      BEGIN --DECLARE

        DECLARE @Level3ID UNIQUEIDENTIFIER ,
          @NumberIs BIGINT ,
          @NumberF NVARCHAR(MAX);

      END;

      BEGIN --Set info

        SET @Level3ID = Company.f_AccountLevel3GetIDByNumber(51201);

        SELECT  @NumberIs = COALESCE(MAX(t.NumberIs), 5120100000) + 1
        FROM    Company.t_Account AS t
        WHERE   t.Level3ID = @Level3ID;

        SET @NumberF = @NumberIs;

      END;

      DELETE  FROM @IDs;

      INSERT  INTO Company.t_Account
              ( Level3ID ,
                Level3 ,
                SectionID ,
                LinkWithID ,
                LinkWith ,
                IsMasterLink ,
                NumberIs ,
                NumberF ,
                NumberNet ,
                Name ,
                CurrencyID ,
                Currency ,
                CurrencyTypeIs ,
                Limit ,
                LimitF ,
                LimitD ,
                DescriptionIs
              )
      OUTPUT  Inserted.ID
              INTO @IDs ( ID )
      VALUES  ( @Level3ID ,
                Company.f_AccountLevel3GetName(@Level3ID) ,
                38 ,
                @ID ,
                @Name ,
                1 ,
                @NumberIs ,
                @NumberF ,
                SUBSTRING(@NumberF, 6, 5) ,
                @Name ,
                @AccountCurrencyID ,
                Currencys.f_CurrencyGetName(@AccountCurrencyID) ,
                Currencys.f_CurrencyGetTypeIs(@AccountCurrencyID) ,
                0 ,
                Currencys.f_Format(@AccountCurrencyID, 0) ,
                0 ,
                N''
              );

      SET @AccountID = ( SELECT TOP ( 1 )
                                ID
                         FROM   @IDs
                         ORDER BY ID
                       );

    END;

    BEGIN --Insert phones

      SET @Return = -2;

      INSERT  INTO Company.t_BookPhone
              ( OwnerID ,
                NumberIs ,
                SectionID ,
                NumberType ,
                LanguageCodeID ,
                ExtensionIs
              )
      SELECT DISTINCT
              @ID ,
              t.NumberIs ,
              38 ,
              t.TypeIs ,
              t.LanguageCodeID ,
              t.ExtensionIs
      FROM    @Phones AS t;

    END;

    BEGIN --Insert social media

      SET @Return = -4;

      INSERT  INTO Company.t_SocialMedia
              ( OwnerID ,
                AccountIs ,
                SectionID ,
                TypeID
              )
      SELECT  @ID ,
              t.AccountIs ,
              38 ,
              t.TypeID
      FROM    @SocialMedia AS t;

    END;

    BEGIN --Format

      EXECUTE Company.s_BankFormat @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_BankMoving
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

    BEGIN --Insert event account

      SET @Return = -1;

      SET @EventBase += Company.f_AccountGetName(@AccountID);

      INSERT  INTO Company.t_AccountMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @AccountID ,
                @EventBase ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    COMMIT TRANSACTION;

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  @Return;

  END CATCH;

END;






GO
