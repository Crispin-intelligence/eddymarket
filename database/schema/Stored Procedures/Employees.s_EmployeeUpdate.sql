SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_EmployeeUpdate]
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
  @IsSyncImage BIT ,
  @ImageID IMAGE ,
  @ImagePathID NVARCHAR(MAX) ,
  @IsSyncImageID BIT ,
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
      WHERE   SectionID = 33
              AND LinkWithID = @ID
              AND s.IsMasterLink = 1
      ORDER BY s.ID;

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Employees.t_Employee AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;
      UPDATE  Employees.t_Employee
      SET     Name = @Name ,
              TypeID = @TypeID ,
              Gender = @Gender ,
              NationalityID = @NationalityID ,
              Birthday = @Birthday ,
              StatesID = @StatesID ,
              RegionID = @RegionID ,
              StreetID = @StreetID ,
              BuildingID = @BuildingID ,
              FloorID = @FloorID ,
              PostalCodeID = @PostalCodeID ,
              AddressNote = @AddressNote ,
              DescriptionIs = @DescriptionIs ,
              ImageIs = @Image ,
              ImagePath = @ImagePath ,
              IsSyncImage = @IsSyncImage ,
              ImageID = @ImageID ,
              ImagePathID = @ImagePathID ,
              IsSyncImageID = @IsSyncImageID
      WHERE   ID = @ID;

    END;

    BEGIN --Insert phones

      SET @Return = -2;

      DELETE  FROM Company.t_BookPhone
      WHERE   OwnerID = @ID
              AND SectionID = 33;

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

      DELETE  FROM Company.t_SocialMedia
      WHERE   OwnerID = @ID
              AND SectionID = 33;

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

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix

      BEGIN --t_ItemProduction

        UPDATE  Items.t_ItemProduction
        SET     Employee = @Name
        WHERE   EmployeeID = @ID;

      END;

      BEGIN --t_Account

        UPDATE  Company.t_Account
        SET     LinkWith = @Name ,
                Name = @Name
        WHERE   SectionID = 33
                AND LinkWithID = @ID
                AND NumberIs BETWEEN 4210100000 AND 4210199999;

      END;

      BEGIN --t_Account

        UPDATE  Company.t_Account
        SET     LinkWith = @Name ,
                Name = @Name + ' (رواتب)'
        WHERE   SectionID = 33
                AND LinkWithID = @ID
                AND NumberIs BETWEEN 6310100000 AND 6310199999;

      END;

      BEGIN --t_Vacation

        UPDATE  Employees.t_Vacation
        SET     Employee = @Name
        WHERE   EmployeeID = @ID;

      END;

      BEGIN --t_Discount

        UPDATE  Employees.t_Discount
        SET     Employee = @Name
        WHERE   EmployeeID = @ID;

        UPDATE  Employees.t_Discount
        SET     FromEmployee = @Name
        WHERE   FromEmployeeID = @ID;

      END;

      BEGIN --t_DiscountHistory

        UPDATE  Employees.t_DiscountHistory
        SET     Employee = @Name
        WHERE   EmployeeID = @ID;

        UPDATE  Employees.t_DiscountHistory
        SET     FromEmployee = @Name
        WHERE   FromEmployeeID = @ID;

      END;

      BEGIN --t_Bonus

        UPDATE  Employees.t_Bonus
        SET     Employee = @Name
        WHERE   EmployeeID = @ID;

        UPDATE  Employees.t_Bonus
        SET     FromEmployee = @Name
        WHERE   FromEmployeeID = @ID;

      END;

      BEGIN --t_BonusHistory

        UPDATE  Employees.t_BonusHistory
        SET     Employee = @Name
        WHERE   EmployeeID = @ID;

        UPDATE  Employees.t_BonusHistory
        SET     FromEmployee = @Name
        WHERE   FromEmployeeID = @ID;

      END;

      BEGIN --t_Shift

        UPDATE  Employees.t_Shift
        SET     Employee = @Name
        WHERE   EmployeeID = @ID;

      END;

      BEGIN --t_ShiftHistory

        UPDATE  Employees.t_ShiftHistory
        SET     Employee = @Name
        WHERE   EmployeeID = @ID;

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

      BEGIN --t_Customer

        UPDATE  Customers.t_Customer
        SET     EmployeeInternet = @Name
        WHERE   EmployeeIDInternet = @ID;

      END;
      
      BEGIN; --t_DeliveryService

        UPDATE  Invoices.t_DeliveryService
        SET     AccountEmployee = @Name
        WHERE   AccountEmployeeID = @AccountID;

        UPDATE  Invoices.t_DeliveryServiceHistory
        SET     AccountEmployee = @Name
        WHERE   AccountEmployeeID = @AccountID;

        UPDATE  Invoices.t_DeliveryServiceDeleted
        SET     AccountEmployee = @Name
        WHERE   AccountEmployeeID = @AccountID;

      END;
      
    END;

    IF @CurrencyIDOld <> @CurrencyID
    BEGIN; --Fix Balance

      UPDATE  Company.t_Account
      SET     CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID) ,
              IsSync = 0
      WHERE   SectionID = 33
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
              PurchasingReturnProfit = [Invoices].f_PurchasingReturnGetProfitByAccountVendorID(ID) ,
              SoldTotal = [Invoices].[f_SoldGetTotalByAccountCustomerID](ID) ,
              SoldProfit = [Invoices].[f_SoldGetProfitByAccountCustomerID](ID) ,
              SoldReturnTotal = [Invoices].[f_SoldReturnGetTotalByAccountCustomerID](ID) ,
              SoldReturnProfit = [Invoices].[f_SoldReturnGetProfitByAccountCustomerID](ID) ,
              QuotationTotal = Quotations.[f_QuotationGetTotalByAccountID](ID) ,
              QuotationProfit = Quotations.[f_QuotationGetProfitByAccountID](ID)
      WHERE   SectionID = 33
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
      WHERE   SectionID = 33
              AND LinkWithID = @ID;

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
