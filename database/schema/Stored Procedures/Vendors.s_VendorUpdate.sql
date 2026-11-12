SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Vendors].[s_VendorUpdate]
  @Name NVARCHAR(450) ,
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
  @CurrencyID UNIQUEIDENTIFIER ,
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
        @AccountID UNIQUEIDENTIFIER ,
        @CurrencyIDOld UNIQUEIDENTIFIER;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @AccountID = s.ID ,
              @CurrencyIDOld = s.CurrencyID
      FROM    Company.t_Account AS s
      WHERE   SectionID = 67
              AND LinkWithID = @ID
              AND s.IsMasterLink = 1
      ORDER BY s.ID;

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Vendors.t_Vendor AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Vendors.t_Vendor
      SET     Name = @Name ,
              TitleID = @TitleID ,
              ClassificationID = @ClassificationID ,
              StatesID = @StatesID ,
              RegionID = @RegionID ,
              StreetID = @StreetID ,
              BuildingID = @BuildingID ,
              FloorID = @FloorID ,
              PostalCodeID = @PostalCodeID ,
              AddressNote = @AddressNote ,
              NumberCurrency = @NumberCurrency ,
              CallAfter = @CallAfter ,
              Payment = @Payment ,
              PaymentF = Currencys.f_Format(@CurrencyID, @Payment) ,
              PaymentD = @Payment / Currencys.f_CurrencyGetExchangeRate(@CurrencyID) ,
              PaymentEvery = @PaymentEvery ,
              PaymentEveryType = @PaymentEveryType ,
              DescriptionIs = @DescriptionIs ,
              ImageIs = @ImageIs ,
              ImagePath = @ImagePath ,
              IsSyncImage = IIF(@ImagePath = '', 0, 1)
      WHERE   ID = @ID;

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

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix

      BEGIN --t_Account

        UPDATE  Company.t_Account
        SET     LinkWith = @Name ,
                Name = @Name
        WHERE   SectionID = 67
                AND IsMasterLink = 1
                AND LinkWithID = @ID;

        UPDATE  Company.t_Account
        SET     LinkWith = @Name ,
                Name = @Name + ' (الضريبة)'
        WHERE   SectionID = 67
                AND IsMasterLink = 0
                AND LinkWithID = @ID
                AND NumberIs BETWEEN 4421000000 AND 4421099999;

      END;

      BEGIN --t_Address

        UPDATE  Location.t_Address
        SET     OwnerName = @Name
        WHERE   SectionID = 67
                AND OwnerID = @ID;

      END;

      BEGIN --t_VendorSchedulePayment

        UPDATE  Vendors.t_VendorSchedulePayment
        SET     Vendor = @Name
        WHERE   VendorID = @ID;

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

      BEGIN; --t_DeliveryService

        UPDATE  Invoices.t_DeliveryService
        SET     AccountVendor = @Name
        WHERE   AccountVendorID = @AccountID;

        UPDATE  Invoices.t_DeliveryServiceHistory
        SET     AccountVendor = @Name
        WHERE   AccountVendorID = @AccountID;

        UPDATE  Invoices.t_DeliveryServiceDeleted
        SET     AccountVendor = @Name
        WHERE   AccountVendorID = @AccountID;

      END;

    END;

    IF @CurrencyIDOld <> @CurrencyID
    BEGIN; --Fix Balance

      UPDATE  Company.t_Account
      SET     CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID) ,
              IsSync = 0
      WHERE   SectionID = 67
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
              QuotationProfit = Quotations.[f_QuotationGetProfitByAccountID](ID)
      WHERE   SectionID = 67
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
              QuotationProfitF = Currencys.f_Format(CurrencyID, QuotationProfit)
      WHERE   SectionID = 67
              AND LinkWithID = @ID;

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
