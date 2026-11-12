SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Employees].[s_EmployeeInsert]
  @Name NVARCHAR(450) ,
  @Phones Company.td_BookPhone READONLY ,
  @SocialMedia Company.dt_SocialMedia READONLY ,
  @TypeID UNIQUEIDENTIFIER ,
  @Gender TINYINT ,
  @NationalityID UNIQUEIDENTIFIER ,
  @Birthday DATE ,
  @StatesID UNIQUEIDENTIFIER ,
  @RegionID UNIQUEIDENTIFIER ,
  @StreetID UNIQUEIDENTIFIER ,
  @BuildingID UNIQUEIDENTIFIER ,
  @FloorID UNIQUEIDENTIFIER ,
  @PostalCodeID UNIQUEIDENTIFIER ,
  @AddressNote NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @Image IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
  @ImageID IMAGE ,
  @ImagePathID NVARCHAR(MAX) ,
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

      DECLARE @Return INT ,
        @AccountEvent NVARCHAR(MAX) ,
        @AccountIDSalary UNIQUEIDENTIFIER;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Employees.t_Employee
              ( ID ,
                Name ,
                TypeID ,
                Gender ,
                NationalityID ,
                Birthday ,
                StatesID ,
                RegionID ,
                StreetID ,
                BuildingID ,
                FloorID ,
                PostalCodeID ,
                AddressNote ,
                DescriptionIs ,
                ImageIs ,
                ImagePath ,
                IsSyncImage ,
                ImageID ,
                ImagePathID ,
                IsSyncImageID ,
                CurrencyID
              )
      VALUES  ( @ID ,
                @Name ,
                @TypeID ,
                @Gender ,
                @NationalityID ,
                @Birthday ,
                @StatesID ,
                @RegionID ,
                @StreetID ,
                @BuildingID ,
                @FloorID ,
                @PostalCodeID ,
                @AddressNote ,
                @DescriptionIs ,
                @Image ,
                @ImagePath ,
                IIF(@ImagePath = N'', 0, 1) ,
                @ImageID ,
                @ImagePathID ,
                IIF(@ImagePathID = N'', 0, 1) ,
                @AccountCurrencyID
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

        SET @Level3ID = Company.f_AccountLevel3GetIDByNumber(42101);

        SELECT  @NumberIs = COALESCE(MAX(t.NumberIs), 4210100000) + 1
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
                33 ,
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

    BEGIN --Insert salary account

      BEGIN --Set info

        SET @Level3ID = Company.f_AccountLevel3GetIDByNumber(63101);

        SELECT  @NumberIs = COALESCE(MAX(t.NumberIs), 6310100000) + 1
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
                33 ,
                @ID ,
                @Name ,
                0 ,
                @NumberIs ,
                @NumberF ,
                SUBSTRING(@NumberF, 6, 5) ,
                @Name + ' (رواتب)' ,
                @AccountCurrencyID ,
                Currencys.f_CurrencyGetName(@AccountCurrencyID) ,
                Currencys.f_CurrencyGetTypeIs(@AccountCurrencyID) ,
                0 ,
                Currencys.f_Format(@AccountCurrencyID, 0) ,
                0 ,
                N''
              );

      SET @AccountIDSalary = ( SELECT TOP ( 1 )
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
              33 ,
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
              33 ,
              t.TypeID
      FROM    @SocialMedia AS t;

    END;

    BEGIN --Format

      EXECUTE [Employees].s_EmployeeFormat @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Employees.t_EmployeeMoving
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

      SET @AccountEvent = @EventBase + Company.f_AccountGetName(@AccountID);

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
                @AccountEvent ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    BEGIN --Insert event account salary

      SET @Return = -1;

      SET @AccountEvent = @EventBase + Company.f_AccountGetName(@AccountIDSalary);

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
                @AccountIDSalary ,
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
