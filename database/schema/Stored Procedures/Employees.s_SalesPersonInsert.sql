SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_SalesPersonInsert]
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
  @CommissionRate DECIMAL(4, 2) ,
  @CommissionRateType TINYINT ,
  @CommissionRateOn TINYINT ,
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

      DECLARE @AccountIDSaleCommissions UNIQUEIDENTIFIER ,
        @AccountEvent NVARCHAR(MAX) ,
        @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Employees.t_SalesPerson
              ( ID ,
                Name ,
                StatesID ,
                RegionID ,
                StreetID ,
                BuildingID ,
                FloorID ,
                PostalCodeID ,
                AddressNote ,
                CommissionRate ,
                CommissionRateType ,
                CommissionRateOn ,
                DescriptionIs
              )
      VALUES  ( @ID ,
                @Name ,
                @StatesID ,
                @RegionID ,
                @StreetID ,
                @BuildingID ,
                @FloorID ,
                @PostalCodeID ,
                @AddressNote ,
                @CommissionRate ,
                @CommissionRateType ,
                @CommissionRateOn ,
                @DescriptionIs
              );

    END;

    BEGIN --Insert Account

      SET @Return = -5;

      BEGIN --DECLARE

        DECLARE @Level3ID UNIQUEIDENTIFIER ,
          @NumberIs BIGINT ,
          @NumberF NVARCHAR(MAX);

      END;

      BEGIN --Set info

        SET @Level3ID = Company.f_AccountLevel3GetIDByNumber(46101);

        SELECT  @NumberIs = COALESCE(MAX(t.NumberIs), 4610100000) + 1
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
                149 ,
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

    BEGIN --Insert Sale Commissions Account

      BEGIN --Set info

        SET @Level3ID = Company.f_AccountLevel3GetIDByNumber(70108);

        SELECT  @NumberIs = COALESCE(MAX(t.NumberIs), 7010800000) + 1
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
                149 ,
                @ID ,
                @Name ,
                0 ,
                @NumberIs ,
                @NumberF ,
                SUBSTRING(@NumberF, 6, 5) ,
                @Name + ' (عمولات البيع)' ,
                @AccountCurrencyID ,
                Currencys.f_CurrencyGetName(@AccountCurrencyID) ,
                Currencys.f_CurrencyGetTypeIs(@AccountCurrencyID) ,
                0 ,
                Currencys.f_Format(@AccountCurrencyID, 0) ,
                0 ,
                N''
              );

      SET @AccountIDSaleCommissions = ( SELECT TOP ( 1 )
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
                LanguageCode ,
                ExtensionIs
              )
      SELECT DISTINCT
              @ID ,
              t.NumberIs ,
              149 ,
              t.TypeIs ,
              t.LanguageCodeID ,
              Alls.f_LanguageCodeGetName(t.LanguageCodeID) ,
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
              149 ,
              t.TypeID
      FROM    @SocialMedia AS t;

    END;

    BEGIN --Format

      UPDATE  Employees.t_SalesPerson
      SET     Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                     WHEN N'' THEN N''
                                                                     ELSE N': ' + t.ExtensionIs
                                                                   END AS [text()]
                                       FROM   Company.t_BookPhone AS t
                                       WHERE  t.OwnerID = t_SalesPerson.ID
                                              AND t.SectionID = 149
                                     FOR
                                       XML PATH('')
                                     )) ,
              PhonesC = ( SELECT  COUNT(t.ID)
                          FROM    Company.t_BookPhone AS t
                          WHERE   t.OwnerID = t_SalesPerson.ID
                                  AND t.SectionID = 149
                        ) ,
              SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
                                            FROM    Company.t_SocialMedia AS t
                                            WHERE   t.OwnerID = t_SalesPerson.ID
                                                    AND t.SectionID = 149
                                          FOR
                                            XML PATH('')
                                          )) ,
              SocialMediaC = ( SELECT COUNT(t.ID)
                               FROM   Company.t_SocialMedia AS t
                               WHERE  t.OwnerID = t_SalesPerson.ID
                                      AND t.SectionID = 149
                             ) ,
              StatesIs = Location.f_StatesGetName(StatesID) ,
              RegionIs = Location.f_RegionGetName(RegionID) ,
              Street = Location.f_StreetGetName(StreetID) ,
              Building = Location.f_BuildingGetName(BuildingID) ,
              FloorIs = Location.f_FloorGetName(FloorID) ,
              PostalCode = Location.f_PostalCodeGetName(PostalCodeID)
      WHERE   ID = @ID;

      UPDATE  Employees.t_SalesPerson
      SET     AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
      WHERE   ID = @ID;

      UPDATE  Employees.t_SalesPerson
      SET     SearchText = Employees.f_SalesPersonSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Employees.t_SalesPersonMoving
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

    BEGIN --Insert Event Sale Commissions Account

      SET @Return = -1;

      SET @AccountEvent = @EventBase + Company.f_AccountGetName(@AccountIDSaleCommissions);

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
                @AccountIDSaleCommissions ,
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
