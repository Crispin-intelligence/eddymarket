SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerInsert]
  @IDNumber NVARCHAR(MAX) ,
  @IDDoor INT ,
  @Name NVARCHAR(450) ,
  @NameAR NVARCHAR(MAX) ,
  @Reference NVARCHAR(MAX) ,
  @Phones Company.td_BookPhone READONLY ,
  @SocialMedia Company.dt_SocialMedia READONLY ,
  @Gender TINYINT ,
  @Birthday DATE ,
  @AgeRangeID UNIQUEIDENTIFIER ,
  @TitleID UNIQUEIDENTIFIER ,
  @ClassificationID UNIQUEIDENTIFIER ,
  @SalesPersonID UNIQUEIDENTIFIER ,
  @NationalityID UNIQUEIDENTIFIER ,
  @StatesID UNIQUEIDENTIFIER ,
  @RegionID UNIQUEIDENTIFIER ,
  @StreetID UNIQUEIDENTIFIER ,
  @BuildingID UNIQUEIDENTIFIER ,
  @FloorID UNIQUEIDENTIFIER ,
  @PostalCodeID UNIQUEIDENTIFIER ,
  @AddressNote NVARCHAR(MAX) ,
  @NumberCurrency NVARCHAR(MAX) ,
  @CallAfter DATETIME ,
  @DescriptionIs NVARCHAR(MAX) ,
  @ImageIs IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
  @ImageThumbnail IMAGE ,
  @ImageID IMAGE ,
  @ImageIDPath NVARCHAR(MAX) ,
  @ImageIDThumbnail IMAGE ,
  @AccountCurrencyID UNIQUEIDENTIFIER ,
  @LicenseInternet BIT ,
  @EmployeeIDInternet UNIQUEIDENTIFIER ,
  @InternetPackageID UNIQUEIDENTIFIER ,
  @StartFromInternet DATE ,
  @NotificationBeforeDaysInternet TINYINT ,
  @UserNameInternet NVARCHAR(MAX) ,
  @PasswordInternet NVARCHAR(MAX) ,
  @PricingType TINYINT ,
  @PriceIncreaseRate DECIMAL(4, 2) ,
  @PaymentMethod TINYINT ,
  @MaximumDebtInvoiceCurrencyID UNIQUEIDENTIFIER ,
  @MaximumDebtInvoice FLOAT ,
  @FromWFP BIT ,
  @CustomerGroupIDs NVARCHAR(MAX) ,
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

      INSERT  INTO Customers.t_Customer
              ( ID ,
                IDNumber ,
                IDDoor ,
                Name ,
                NameAR ,
                Reference ,
                Gender ,
                Birthday ,
                AgeIs ,
                AgeRangeID ,
                AgeRange ,
                TitleID ,
                ClassificationID ,
                SalesPersonID ,
                NationalityID ,
                StatesID ,
                RegionID ,
                StreetID ,
                BuildingID ,
                FloorID ,
                PostalCodeID ,
                AddressNote ,
                NumberCurrency ,
                CallAfter ,
                DescriptionIs ,
                ImageIs ,
				ImagePath,
				IsSyncImage,
                ImageThumbnail ,
                ImageID ,
				ImageIDPath,
				IsSyncImageID,
                ImageIDThumbnail ,
                LicenseInternet ,
                EmployeeIDInternet ,
                EmployeeInternet ,
                InternetPackageID ,
                InternetPackage ,
                StartFromInternet ,
                ActiveToInternet ,
                NotificationBeforeDaysInternet ,
                NotificationDateInternet ,
                NotificationARInternet ,
                NotificationENInternet ,
                UserNameInternet ,
                PasswordInternet ,
                PricingType ,
                PriceIncreaseRate ,
                PaymentMethod ,
                MaximumDebtInvoiceCurrencyID ,
                MaximumDebtInvoiceCurrency ,
                MaximumDebtInvoice ,
                MaximumDebtInvoiceF ,
                MaximumDebtInvoiceD ,
                FromWFP
              )
      VALUES  ( @ID ,
                @IDNumber ,
                @IDDoor ,
                @Name ,
                @NameAR ,
                @Reference ,
                @Gender ,
                @Birthday ,
                DateTimes.f_GetAge(@Birthday) ,
                @AgeRangeID ,
                Customers.f_AgeRangeGetName(@AgeRangeID) ,
                @TitleID ,
                @ClassificationID ,
                @SalesPersonID ,
                @NationalityID ,
                @StatesID ,
                @RegionID ,
                @StreetID ,
                @BuildingID ,
                @FloorID ,
                @PostalCodeID ,
                @AddressNote ,
                @NumberCurrency ,
                @CallAfter ,
                @DescriptionIs ,
                @ImageIs ,
                @ImagePath ,
                IIF(@ImagePath = N'', 0, 1) ,
                @ImageThumbnail ,
                @ImageID ,
                @ImageIDPath ,
                IIF(@ImageIDPath = N'', 0, 1) ,
                @ImageIDThumbnail ,
                @LicenseInternet ,
                @EmployeeIDInternet ,
                Employees.f_EmployeeGetName(@EmployeeIDInternet) ,
                @InternetPackageID ,
                Customers.f_InternetPackageGetName(@InternetPackageID) ,
                @StartFromInternet ,
                @StartFromInternet ,
                @NotificationBeforeDaysInternet ,
                DATEADD(DAY, 0 - @NotificationBeforeDaysInternet, @StartFromInternet) ,
                N'سينتهي إشتراك الإنترنت قريبا: ' ,
                N'Internet Subscription Will End Soon: ' ,
                @UserNameInternet ,
                @PasswordInternet ,
                @PriceIncreaseRate ,
                @PricingType ,
                @PaymentMethod ,
                @MaximumDebtInvoiceCurrencyID ,
                Currencys.f_CurrencyGetName(@MaximumDebtInvoiceCurrencyID) ,
                @MaximumDebtInvoice ,
                Currencys.f_Format(@MaximumDebtInvoiceCurrencyID, @MaximumDebtInvoice) ,
                @MaximumDebtInvoice / Currencys.f_CurrencyGetExchangeRate(@MaximumDebtInvoiceCurrencyID) ,
                @FromWFP
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

        SET @Level3ID = Company.f_AccountLevel3GetIDByNumber(41101);

        SELECT  @NumberIs = COALESCE(MAX(t.NumberIs), 4110100000) + 1
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
                15 ,
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

        DECLARE @Level3IDTax UNIQUEIDENTIFIER = Company.f_AccountLevel3GetIDByNumber(44270);

        DECLARE @AccountIDTax UNIQUEIDENTIFIER;

        SELECT  @NumberIs = COALESCE(MAX(t.NumberIs), 4427000000) + 1
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
                15 ,
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
              15 ,
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
              15 ,
              t.TypeID
      FROM    @SocialMedia AS t;

    END;

    BEGIN --Insert users

      INSERT  INTO Customers.t_CustomerGroupDetail
              ( CustomerGroupID ,
                CustomerID ,
                Customer
              )
      SELECT DISTINCT
              t.ID ,
              @ID ,
              @Name
      FROM    Alls.[CastArrayToListGuid](@CustomerGroupIDs) AS t;

    END;

    BEGIN --Fix t_Customer

      UPDATE  Customers.t_Customer
      SET     Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                     WHEN N'' THEN N''
                                                                     ELSE N': ' + t.ExtensionIs
                                                                   END AS [text()]
                                       FROM   Company.t_BookPhone AS t
                                       WHERE  t.OwnerID = t_Customer.ID
                                              AND t.SectionID = 15
                                     FOR
                                       XML PATH('')
                                     )) ,
              PhonesC = ( SELECT  COUNT(t.ID)
                          FROM    Company.t_BookPhone AS t
                          WHERE   t.OwnerID = t_Customer.ID
                                  AND t.SectionID = 15
                        ) ,
              SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
                                            FROM    Company.t_SocialMedia AS t
                                            WHERE   t.OwnerID = t_Customer.ID
                                                    AND t.SectionID = 15
                                          FOR
                                            XML PATH('')
                                          )) ,
              SocialMediaC = ( SELECT COUNT(t.ID)
                               FROM   Company.t_SocialMedia AS t
                               WHERE  t.OwnerID = t_Customer.ID
                                      AND t.SectionID = 15
                             ) ,
              Title = Customers.f_TitleGetName(TitleID) ,
              Classification = Customers.f_ClassificationGetName(ClassificationID) ,
              SalesPerson = Employees.f_SalesPersonGetName(SalesPersonID) ,
              Nationality = Employees.f_NationalityGetName(@NationalityID) ,
              StatesIs = Location.f_StatesGetName(StatesID) ,
              RegionIs = Location.f_RegionGetName(RegionID) ,
              Street = Location.f_StreetGetName(StreetID) ,
              Building = Location.f_BuildingGetName(BuildingID) ,
              FloorIs = Location.f_FloorGetName(FloorID) ,
              PostalCode = Location.f_PostalCodeGetName(PostalCodeID) ,
              CallAfterF = FORMAT(CallAfter, 't') ,
              GroupNames = Alls.f_FixXML(( SELECT N', ' + t1.Name AS [text()]
                                           FROM   Customers.t_CustomerGroupDetail AS t
                                           LEFT JOIN Customers.t_CustomerGroup AS t1 ON t1.ID = t.CustomerGroupID
                                           WHERE  t.CustomerID = t_Customer.ID
                                         FOR
                                           XML PATH('')
                                         )) ,
              GroupCounts = ( SELECT  COUNT(t.ID)
                              FROM    Customers.t_CustomerGroupDetail AS t
                              WHERE   t.CustomerID = t_Customer.ID
                            )
      WHERE   ID = @ID;

      UPDATE  Customers.t_Customer
      SET     AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
      WHERE   ID = @ID;

      UPDATE  Customers.t_Customer
      SET     SearchText = Customers.f_CustomerSearchTextGet(ID)
      WHERE   ID = @ID;
	  
    END;

    BEGIN --Fix t_InternetPackage

      UPDATE  Customers.t_InternetPackage
      SET     TotalCustomers += 1
      WHERE   ID = @InternetPackageID;

    END;
      
    BEGIN --Fix t_AgeRange

      UPDATE  Customers.t_AgeRange
      SET     CustomerC += 1
      WHERE   ID = @AgeRangeID;

    END;

    BEGIN --Fix t_CustomerGroup
		
      UPDATE  Customers.t_CustomerGroup
      SET     CustomerNames = Alls.f_FixXML(( SELECT  N', ' + s.Customer AS [text()]
                                              FROM    Customers.t_CustomerGroupDetail AS s
                                              WHERE   s.CustomerGroupID = t_CustomerGroup.ID
                                            FOR
                                              XML PATH('')
                                            )) ,
              CustomerCount = ( SELECT  COUNT(*)
                                FROM    Customers.t_CustomerGroupDetail AS s
                                WHERE   s.CustomerGroupID = t_CustomerGroup.ID
                              )
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   Customers.t_CustomerGroupDetail AS s
                       WHERE  s.CustomerID = @ID
                              AND s.CustomerGroupID = t_CustomerGroup.ID );

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Customers.t_CustomerMoving
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
