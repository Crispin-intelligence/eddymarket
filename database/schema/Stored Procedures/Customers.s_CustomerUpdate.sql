SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerUpdate]
  @IDNumber NVARCHAR(MAX) ,
  @IDDoor INT ,
  @Name NVARCHAR(450) ,
  @NameAR NVARCHAR(MAX) ,
  @Reference NVARCHAR(MAX) ,
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
  @CurrencyID UNIQUEIDENTIFIER ,
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
        @NameOld NVARCHAR(450) ,
        @InternetPackageIDOld UNIQUEIDENTIFIER ,
        @AgeRangeIDOld UNIQUEIDENTIFIER ,
        @AccountID UNIQUEIDENTIFIER ,
        @CurrencyIDOld UNIQUEIDENTIFIER;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name ,
              @InternetPackageIDOld = s.InternetPackageID ,
              @AgeRangeIDOld = s.AgeRangeID
      FROM    Customers.t_Customer AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

      SELECT TOP ( 1 )
              @AccountID = s.ID ,
              @CurrencyIDOld = s.CurrencyID
      FROM    Company.t_Account AS s
      WHERE   SectionID = 15
              AND LinkWithID = @ID
              AND s.IsMasterLink = 1
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Customers.t_Customer
      SET     IDNumber = @IDNumber ,
              IDDoor = @IDDoor ,
              Name = @Name ,
              NameAR = @NameAR ,
              Reference = @Reference ,
              Gender = @Gender ,
              Birthday = @Birthday ,
              AgeIs = DateTimes.f_GetAge(@Birthday) ,
              AgeRangeID = @AgeRangeID ,
              AgeRange = Customers.f_AgeRangeGetName(@AgeRangeID) ,
              TitleID = @TitleID ,
              ClassificationID = @ClassificationID ,
              SalesPersonID = @SalesPersonID ,
              NationalityID = @NationalityID ,
              StatesID = @StatesID ,
              RegionID = @RegionID ,
              StreetID = @StreetID ,
              BuildingID = @BuildingID ,
              FloorID = @FloorID ,
              PostalCodeID = @PostalCodeID ,
              AddressNote = @AddressNote ,
              NumberCurrency = @NumberCurrency ,
              CallAfter = @CallAfter ,
              DescriptionIs = @DescriptionIs ,
              ImageIs = @ImageIs ,
              ImagePath = @ImagePath ,
              IsSyncImage = IIF(@ImagePath = '', 0, 1) ,
              ImageThumbnail = @ImageThumbnail ,
              ImageID = @ImageID ,
              ImageIDPath = @ImageIDPath ,
              IsSyncImageID = IIF(@ImageIDPath = '', 0, 1)  ,
              ImageIDThumbnail = @ImageIDThumbnail ,
              EmployeeIDInternet = @EmployeeIDInternet ,
              EmployeeInternet = Employees.f_EmployeeGetName(@EmployeeIDInternet) ,
              InternetPackageID = @InternetPackageID ,
              InternetPackage = Customers.f_InternetPackageGetName(@InternetPackageID) ,
              StartFromInternet = @StartFromInternet ,
              ActiveToInternet = COALESCE(( SELECT  MAX(s.ActiveTo)
                                            FROM    ( SELECT  s1.ActiveTo ,
                                                              s1.CustomerID
                                                      FROM    Invoices.t_InternetSubscription AS s1
                                                      UNION ALL
                                                      SELECT  s1.ActiveTo ,
                                                              s1.CustomerID
                                                      FROM    Invoices.t_InternetSubscriptionHistory AS s1
                                                    ) AS s
                                            WHERE   s.CustomerID = t_Customer.ID
                                          ), @StartFromInternet) ,
              NotificationBeforeDaysInternet = @NotificationBeforeDaysInternet ,
              NotificationDateInternet = DATEADD(DAY, 0 - @NotificationBeforeDaysInternet, ActiveToInternet) ,
              UserNameInternet = @UserNameInternet ,
              PasswordInternet = @PasswordInternet ,
              PricingType = @PricingType ,
              PriceIncreaseRate = @PriceIncreaseRate ,
              PaymentMethod = @PaymentMethod ,
              MaximumDebtInvoiceCurrencyID = @MaximumDebtInvoiceCurrencyID ,
              MaximumDebtInvoiceCurrency = Currencys.f_CurrencyGetName(@MaximumDebtInvoiceCurrencyID) ,
              MaximumDebtInvoice = @MaximumDebtInvoice ,
              MaximumDebtInvoiceF = Currencys.f_Format(@MaximumDebtInvoiceCurrencyID, @MaximumDebtInvoice) ,
              MaximumDebtInvoiceD = @MaximumDebtInvoice / Currencys.f_CurrencyGetExchangeRate(@MaximumDebtInvoiceCurrencyID) ,
              FromWFP = @FromWFP
      WHERE   ID = @ID;

      UPDATE  Customers.t_Customer
      SET     ActiveToDayInternet = DAY(ActiveToInternet)
      WHERE   ID = @ID;

    END;

    BEGIN --Format

      EXECUTE [Customers].s_CustomerFormat @ID;

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

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix

      BEGIN --t_Account

        UPDATE  Company.t_Account
        SET     LinkWith = @Name ,
                Name = @Name
        WHERE   SectionID = 15
                AND IsMasterLink = 1
                AND LinkWithID = @ID;

        UPDATE  Company.t_Account
        SET     LinkWith = @Name ,
                Name = @Name + ' (الضريبة)'
        WHERE   SectionID = 15
                AND IsMasterLink = 0
                AND LinkWithID = @ID
                AND NumberIs BETWEEN 4427000000 AND 4427099999;

      END;

      BEGIN --t_Address

        UPDATE  Location.t_Address
        SET     OwnerName = @Name
        WHERE   SectionID = 15
                AND OwnerID = @ID;

      END;

      BEGIN; --t_Purchasing

        UPDATE  Invoices.t_Purchasing
        SET     AccountVendor = @Name
        WHERE   AccountVendorID = @AccountID;
				
        UPDATE  Invoices.t_Purchasing
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @AccountID;

      END;

      BEGIN; --t_PurchasingReturn

        UPDATE  Invoices.t_PurchasingReturn
        SET     AccountVendor = @Name
        WHERE   AccountVendorID = @AccountID;

        UPDATE  Invoices.t_PurchasingReturn
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @AccountID;

      END;

      BEGIN; --t_Sold

        UPDATE  Invoices.t_Sold
        SET     AccountCustomer = @Name
        WHERE   AccountCustomerID = @AccountID;

        UPDATE  Invoices.t_Sold
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @AccountID;

      END;

      BEGIN; --t_SoldReturn

        UPDATE  Invoices.t_SoldReturn
        SET     AccountCustomer = @Name
        WHERE   AccountCustomerID = @AccountID;

        UPDATE  Invoices.t_SoldReturn
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @AccountID;

      END;

      BEGIN --t_InternetSubscription

        UPDATE  Invoices.t_InternetSubscription
        SET     Customer = @Name
        WHERE   CustomerID = @ID;

      END;

      BEGIN; --t_DeliveryService

        UPDATE  Invoices.t_DeliveryService
        SET     AccountCustomer = @Name
        WHERE   AccountCustomerID = @AccountID;

        UPDATE  Invoices.t_DeliveryServiceHistory
        SET     AccountCustomer = @Name
        WHERE   AccountCustomerID = @AccountID;

        UPDATE  Invoices.t_DeliveryServiceDeleted
        SET     AccountCustomer = @Name
        WHERE   AccountCustomerID = @AccountID;

      END;

      BEGIN; --t_CustomerGroupDetail

        UPDATE  Customers.t_CustomerGroupDetail
        SET     Customer = @Name
        WHERE   CustomerID = @ID;

      END;

      BEGIN --Fix t_CustomerGroup
		
        UPDATE  Customers.t_CustomerGroup
        SET     CustomerNames = Alls.f_FixXML(( SELECT  N', ' + t.Customer AS [text()]
                                                FROM    Customers.t_CustomerGroupDetail AS t
                                                WHERE   t.CustomerGroupID = t_CustomerGroup.ID
                                              FOR
                                                XML PATH('')
                                              ))
        WHERE   EXISTS ( SELECT TOP ( 1 )
                                s.ID
                         FROM   Customers.t_CustomerGroupDetail AS s
                         WHERE  s.CustomerID = @ID
                                AND s.CustomerGroupID = t_CustomerGroup.ID );

      END;
			
      BEGIN; --t_CustomerGroupDetail

        UPDATE  Customers.t_CustomerGroupDetail
        SET     Customer = @Name
        WHERE   CustomerID = @ID;

      END;
		   
      BEGIN; --t_CustomerGroup

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

      BEGIN --t_Prescription

        UPDATE  Customers.t_Prescription
        SET     Customer = @Name
        WHERE   CustomerID = @ID;

      END;

      BEGIN --t_FrameJobOrder

        UPDATE  Customers.t_FrameJobOrder
        SET     Customer = @Name
        WHERE   CustomerID = @ID;

      END;
    
      BEGIN --t_FrameJobOrderHistory

        UPDATE  Customers.t_FrameJobOrderHistory
        SET     Customer = @Name
        WHERE   CustomerID = @ID;

      END;

    END;

    IF @CurrencyIDOld <> @CurrencyID
    BEGIN; --Fix Balance

      UPDATE  Company.t_Account
      SET     CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID) ,
              IsSync = 0
      WHERE   SectionID = 15
              AND LinkWithID = @ID;

      UPDATE  Company.t_Account
      SET     Balance = COALESCE(( SELECT CASE t_Account.CurrencyTypeIs
                                            WHEN 0 THEN SUM(t.BalanceD)
                                            WHEN 1 THEN SUM(t.BalanceLL)
                                            ELSE SUM(t.BalanceEuro)
                                          END
                                   FROM   Transactions.t_TransactionDetail AS t
                                   WHERE  t.AccountID = t_Account.ID
                                 ), 0) ,
              DeliveryServicesTotal = [Invoices].[f_DeliveryServiceGetTotalByAccountCustomerID](ID) ,
              DeliveryServicesProfit = [Invoices].[f_DeliveryServiceGetProfitByAccountCustomerID](ID) ,
              PurchasingTotal = [Invoices].[f_PurchasingGetTotalByAccountVendorID](ID) ,
              PurchasingProfit = [Invoices].[f_PurchasingGetProfitByAccountVendorID](ID) ,
              PurchasingReturnTotal = [Invoices].[f_PurchasingReturnGetTotalByAccountVendorID](ID) ,
              PurchasingReturnProfit = [Invoices].[f_PurchasingReturnGetProfitByAccountVendorID](ID) ,
              SoldTotal = [Invoices].[f_SoldGetTotalByAccountCustomerID](ID) ,
              SoldProfit = [Invoices].[f_SoldGetProfitByAccountCustomerID](ID) ,
              SoldReturnTotal = [Invoices].[f_SoldReturnGetTotalByAccountCustomerID](ID) ,
              SoldReturnProfit = [Invoices].[f_SoldReturnGetProfitByAccountCustomerID](ID) ,
              QuotationTotal = Quotations.[f_QuotationGetTotalByAccountID](ID) ,
              QuotationProfit = Quotations.[f_QuotationGetProfitByAccountID](ID) ,
              GymSubscriptionTotal = [Gym].[f_GymSubscriptionGetTotalByAccountID](ID) ,
              GymSubscriptionProfit = [Gym].[f_GymSubscriptionGetProfitByAccountID](ID)
      WHERE   SectionID = 15
              AND LinkWithID = @ID;

      UPDATE  Company.t_Account
      SET     BalanceF = Currencys.f_Format(@CurrencyID, Balance) ,
              DeliveryServicesTotalF = Currencys.f_Format(CurrencyID, DeliveryServicesTotal) ,
              DeliveryServicesProfitF = Currencys.f_Format(CurrencyID, DeliveryServicesProfit) ,
              PurchasingTotalF = Currencys.f_Format(CurrencyID, PurchasingTotal) ,
              PurchasingProfitF = Currencys.f_Format(CurrencyID, PurchasingProfit) ,
              PurchasingReturnTotalF = Currencys.f_Format(CurrencyID, PurchasingReturnTotal) ,
              PurchasingReturnProfitF = Currencys.f_Format(CurrencyID, PurchasingReturnProfit) ,
              SoldTotalF = Currencys.f_Format(CurrencyID, SoldTotal) ,
              SoldProfitF = Currencys.f_Format(CurrencyID, SoldProfit) ,
              SoldReturnTotalF = Currencys.f_Format(CurrencyID, SoldReturnTotal) ,
              SoldReturnProfitF = Currencys.f_Format(CurrencyID, SoldReturnProfit) ,
              QuotationTotalF = Currencys.f_Format(CurrencyID, QuotationTotal) ,
              QuotationProfitF = Currencys.f_Format(CurrencyID, QuotationProfit) ,
              GymSubscriptionTotalF = Currencys.f_Format(CurrencyID, GymSubscriptionTotal) ,
              GymSubscriptionProfitF = Currencys.f_Format(CurrencyID, GymSubscriptionProfit)
      WHERE   SectionID = 15
              AND LinkWithID = @ID;

      UPDATE  Customers.t_Customer
      SET     InternetSubscriptionTotal = [Invoices].[f_InternetSubscriptionGetTotalByCustomerID](ID) ,
              InternetSubscriptionProfit = [Invoices].[f_InternetSubscriptionGetProfitByCustomerID](ID) ,
              FrameJobOrderTotal = Customers.[f_FrameJobOrderGetTotalByCustomerID](ID) ,
              FrameJobOrderProfit = Customers.[f_FrameJobOrderGetProfitByCustomerID](ID)
      WHERE   ID = @ID;
   
      WITH  o AS ( SELECT s1.CurrencyID ,
                          s.InternetSubscriptionTotal ,
                          s.InternetSubscriptionTotalF ,
                          s.InternetSubscriptionProfit ,
                          s.InternetSubscriptionProfitF ,
                          s.FrameJobOrderTotal ,
                          s.FrameJobOrderTotalF ,
                          s.FrameJobOrderProfit ,
                          s.FrameJobOrderProfitF
                   FROM   Customers.t_Customer AS s
                   INNER JOIN Company.t_Account AS s1 ON s1.LinkWithID = s.ID
                                                         AND s1.IsMasterLink = 1
                                                         AND s1.SectionID = 15
                   WHERE  s.ID = @ID
                 )
        UPDATE  o
        SET     o.InternetSubscriptionTotalF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionTotal) ,
                o.InternetSubscriptionProfitF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionProfit) ,
                o.FrameJobOrderTotalF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderTotal) ,
                o.FrameJobOrderProfitF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderProfit);
    
    END;

    IF @InternetPackageIDOld <> @InternetPackageID
    BEGIN --Fix t_InternetPackage

      UPDATE  Customers.t_InternetPackage
      SET     TotalCustomers += 1
      WHERE   ID = @InternetPackageID;

      UPDATE  Customers.t_InternetPackage
      SET     TotalCustomers -= 1
      WHERE   ID = @InternetPackageIDOld;

    END;
     
    IF @AgeRangeIDOld <> @AgeRangeID
    BEGIN --Fix t_InternetPackage

      UPDATE  Customers.t_AgeRange
      SET     CustomerC += 1
      WHERE   ID = @AgeRangeID;

      UPDATE  Customers.t_AgeRange
      SET     CustomerC -= 1
      WHERE   ID = @AgeRangeIDOld;

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
