SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Vendors].[s_VendorInsert]
  @Name NVARCHAR(450) ,
  @Phones Company.td_BookPhone READONLY ,
  @SocialMedia Company.dt_SocialMedia READONLY ,
  @TitleID UNIQUEIDENTIFIER ,
  @ClassificationID UNIQUEIDENTIFIER ,
  @StatesID UNIQUEIDENTIFIER ,
  @RegionID UNIQUEIDENTIFIER ,
  @StreetID UNIQUEIDENTIFIER ,
  @BuildingID UNIQUEIDENTIFIER ,
  @FloorID UNIQUEIDENTIFIER ,
  @PostalCodeID UNIQUEIDENTIFIER ,
  @AddressNote NVARCHAR(MAX) ,
  @NumberCurrency NVARCHAR(MAX) ,
  @CallAfter DATETIME ,
  @Payment FLOAT ,
  @PaymentEvery INT ,
  @PaymentEveryType TINYINT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @ImageIs IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
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

      INSERT  INTO Vendors.t_Vendor
              ( ID ,
                Name ,
                TitleID ,
                ClassificationID ,
                StatesID ,
                RegionID ,
                StreetID ,
                BuildingID ,
                FloorID ,
                PostalCodeID ,
                AddressNote ,
                NumberCurrency ,
                CallAfter ,
                Payment ,
                PaymentF ,
                PaymentD ,
                PaymentEvery ,
                PaymentEveryType ,
                DescriptionIs ,
                ImageIs ,
                ImagePath ,
                IsSyncImage
              )
      VALUES  ( @ID ,
                @Name ,
                @TitleID ,
                @ClassificationID ,
                @StatesID ,
                @RegionID ,
                @StreetID ,
                @BuildingID ,
                @FloorID ,
                @PostalCodeID ,
                @AddressNote ,
                @NumberCurrency ,
                @CallAfter ,
                @Payment ,
                Currencys.f_Format(@AccountCurrencyID, @Payment) ,
                @Payment / Currencys.f_CurrencyGetExchangeRate(@AccountCurrencyID) ,
                @PaymentEvery ,
                @PaymentEveryType ,
                @DescriptionIs ,
                @ImageIs ,
                @ImagePath ,
                IIF(@ImagePath = N'', 0, 1)
              );

    END;

    BEGIN --Insert normal account

      SET @Return = -5;

      BEGIN --DECLARE

        DECLARE @Level3ID UNIQUEIDENTIFIER ,
          @NumberIs BIGINT ,
          @NumberF NVARCHAR(MAX);

      END;

      BEGIN --Set info

        SET @Level3ID = Company.f_AccountLevel3GetIDByNumber(40101);

        SELECT  @NumberIs = COALESCE(MAX(t.NumberIs), 4010100000) + 1
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
                67 ,
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

    BEGIN --Insert tax account

      BEGIN --Set info

        DECLARE @Level3IDTax UNIQUEIDENTIFIER = Company.f_AccountLevel3GetIDByNumber(44210);

        DECLARE @AccountIDTax UNIQUEIDENTIFIER;

        SELECT  @NumberIs = COALESCE(MAX(t.NumberIs), 4421000000) + 1
        FROM    Company.t_Account AS t
        WHERE   t.Level3ID = @Level3IDTax;

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
      VALUES  ( @Level3IDTax ,
                Company.f_AccountLevel3GetName(@Level3IDTax) ,
                67 ,
                @ID ,
                @Name ,
                0 ,
                @NumberIs ,
                @NumberF ,
                SUBSTRING(@NumberF, 6, 5) ,
                @Name + ' (الضريبة)' ,
                @AccountCurrencyID ,
                Currencys.f_CurrencyGetName(@AccountCurrencyID) ,
                Currencys.f_CurrencyGetTypeIs(@AccountCurrencyID) ,
                0 ,
                Currencys.f_Format(@AccountCurrencyID, 0) ,
                0 ,
                N''
              );

      SET @AccountIDTax = ( SELECT TOP ( 1 )
                                    ID
                            FROM    @IDs
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
              67 ,
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
              67 ,
              t.TypeID
      FROM    @SocialMedia AS t;

    END;

    BEGIN --Format

      EXECUTE [Vendors].s_VendorFormat @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Vendors.t_VendorMoving
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

    BEGIN --Insert event account tax

      SET @Return = -1;

      DECLARE @AccountEvent NVARCHAR(MAX) = @EventBase + Company.f_AccountGetName(@AccountIDTax);

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
                @AccountIDTax ,
                @AccountEvent ,
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
