SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountUpdate]
  @Name NVARCHAR(450) ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @Limit FLOAT ,
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
        @NameOld NVARCHAR(450) ,
        @CurrencyIDOld UNIQUEIDENTIFIER ,
        @ExchangeRate DECIMAL(18, 2);

    END;

    BEGIN --Set Info

      SELECT  @CurrencyIDOld = CurrencyID
      FROM    Company.t_Account
      WHERE   ID = @ID;

      SELECT  @ExchangeRate = ExchangeRate
      FROM    Currencys.t_Currency
      WHERE   ID = @CurrencyID;

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Company.t_Account AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update 

      SET @Return = 0;

      UPDATE  Company.t_Account
      SET     Name = @Name ,
              CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID) ,
              Limit = @Limit ,
              LimitF = Currencys.f_Format(@CurrencyID, @Limit) ,
              LimitD = @Limit / @ExchangeRate ,
              DescriptionIs = @DescriptionIs ,
              IsSync = 0
      WHERE   ID = @ID;

      UPDATE  Company.t_Account
      SET     SearchText = Company.f_AccountSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN; --Fix t_Account

      DISABLE TRIGGER Company.tr_Account ON Company.t_Account;
      DISABLE TRIGGER Invoices.tr_Sold ON Invoices.t_Sold;
      DISABLE TRIGGER Invoices.tr_SoldReturn ON Invoices.t_SoldReturn;
      DISABLE TRIGGER Invoices.tr_Purchasing ON Invoices.t_Purchasing;
      DISABLE TRIGGER Invoices.tr_PurchasingReturn ON Invoices.t_PurchasingReturn;
      DISABLE TRIGGER Transactions.tr_TransactionDetail ON Transactions.t_TransactionDetail;

      BEGIN --Account Blocked

        UPDATE  Company.t_AccountUserBlocked
        SET     Account = @Name
        WHERE   AccountID = @ID;

      END;

      BEGIN --Account Merge

        UPDATE  Company.t_AccountMerge
        SET     Account = @Name
        WHERE   AccountID = @ID;

        UPDATE  Company.t_AccountMerge
        SET     AccountWith = @Name
        WHERE   AccountIDWith = @ID;

      END;

      BEGIN; --t_Purchasing

        UPDATE  Invoices.t_Purchasing
        SET     AccountVendor = @Name
        WHERE   AccountVendorID = @ID;
				
        UPDATE  Invoices.t_Purchasing
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @ID;

      END;

      BEGIN; --t_PurchasingReturn

        UPDATE  Invoices.t_PurchasingReturn
        SET     AccountVendor = @Name
        WHERE   AccountVendorID = @ID;

        UPDATE  Invoices.t_PurchasingReturn
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @ID;

      END;

      BEGIN; --t_Sold

        UPDATE  Invoices.t_Sold
        SET     AccountCustomer = @Name
        WHERE   AccountCustomerID = @ID;

        UPDATE  Invoices.t_Sold
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @ID;

      END;

      BEGIN; --t_SoldReturn

        UPDATE  Invoices.t_SoldReturn
        SET     AccountCustomer = @Name
        WHERE   AccountCustomerID = @ID;

        UPDATE  Invoices.t_SoldReturn
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @ID;

      END;

      BEGIN; --Transaction Detail

        UPDATE  Transactions.t_TransactionDetail
        SET     Account = @Name
        WHERE   AccountID = @ID;

      END;

      BEGIN --Transaction Detail By Day

        UPDATE  Transactions.t_TransactionDetailByDay
        SET     Account = @Name
        WHERE   AccountID = @ID;

      END;

      BEGIN --Transaction Detail By Month

        UPDATE  Transactions.t_TransactionDetailByMonth
        SET     Account = @Name
        WHERE   AccountID = @ID;

      END;

      BEGIN --Transaction Detail By Year

        UPDATE  Transactions.t_TransactionDetailByYear
        SET     Account = @Name
        WHERE   AccountID = @ID;

      END;

      BEGIN --Account Group Account

        UPDATE  Company.t_AccountGroupAccount
        SET     Account = @Name
        WHERE   AccountID = @ID;

      END;

      BEGIN --t_User

        UPDATE  Users.t_User
        SET     AccountBoxName = @Name
        WHERE   AccountBoxID = @ID;
    
        UPDATE  Users.t_User
        SET     AccountBoxLLName = @Name
        WHERE   AccountBoxLLID = @ID;
	
        UPDATE  Users.t_User
        SET     AccountBoxEuroName = @Name
        WHERE   AccountBoxEuroID = @ID;

      END;

      BEGIN --Fix t_CloseBox

        UPDATE  Company.t_CloseBox
        SET     FromAccount = @Name
        WHERE   FromAccountID = @ID;

        UPDATE  Company.t_CloseBox
        SET     ToAccount = @Name
        WHERE   ToAccountID = @ID;

      END;

      BEGIN --Fix t_Expense

        UPDATE  Company.t_Expense
        SET     FromAccount = @Name
        WHERE   FromAccountID = @ID;

        UPDATE  Company.t_Expense
        SET     ToAccount = @Name
        WHERE   ToAccountID = @ID;

        UPDATE  Company.t_Expense
        SET     VendorAccount = @Name
        WHERE   VendorAccountID = @ID;

      END;

      BEGIN --Fix t_OpenBox

        UPDATE  Company.t_OpenBox
        SET     FromAccount = @Name
        WHERE   FromAccountID = @ID;

        UPDATE  Company.t_OpenBox
        SET     ToAccount = @Name
        WHERE   ToAccountID = @ID;

      END;

      BEGIN --Fix t_InternetSubscription

        UPDATE  Invoices.t_InternetSubscription
        SET     AccountSale = @Name
        WHERE   AccountSaleID = @ID;

        UPDATE  Invoices.t_InternetSubscription
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @ID;

      END;

      BEGIN --Fix t_GymClass
	  
        UPDATE  Gym.t_GymClass
        SET     AccountEmployee = @Name
        WHERE   AccountEmployeeID = @ID;

      END;

      BEGIN --Fix t_PersonalTrainer
	  
        UPDATE  Gym.t_PersonalTrainer
        SET     AccountEmployee = @Name
        WHERE   AccountEmployeeID = @ID;

      END;

      BEGIN --Fix t_GymSubscription

        UPDATE  Gym.t_GymSubscription
        SET     Account = @Name
        WHERE   AccountID = @ID;

        UPDATE  Gym.t_GymSubscription
        SET     AccountEmployee = @Name
        WHERE   AccountEmployeeID = @ID;

        UPDATE  Gym.t_GymSubscription
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @ID;
		  
        UPDATE  Gym.t_GymSubscriptionClass
        SET     AccountEmployee = @Name
        WHERE   AccountEmployeeID = @ID;

      END;

      BEGIN --Fix t_GymSubscriptionHistory

        UPDATE  Gym.t_GymSubscriptionHistory
        SET     Account = @Name
        WHERE   AccountID = @ID;

        UPDATE  Gym.t_GymSubscriptionHistory
        SET     AccountEmployee = @Name
        WHERE   AccountEmployeeID = @ID;

        UPDATE  Gym.t_GymSubscriptionHistory
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @ID;
		  
        UPDATE  Gym.t_GymSubscriptionHistoryClass
        SET     AccountEmployee = @Name
        WHERE   AccountEmployeeID = @ID;

      END;

      BEGIN --Fix t_GymSubscriptionDeleted

        UPDATE  Gym.t_GymSubscriptionDeleted
        SET     Account = @Name
        WHERE   AccountID = @ID;

        UPDATE  Gym.t_GymSubscriptionDeleted
        SET     AccountEmployee = @Name
        WHERE   AccountEmployeeID = @ID;

        UPDATE  Gym.t_GymSubscriptionDeleted
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @ID;

        UPDATE  Gym.t_GymSubscriptionDeletedClass
        SET     AccountEmployee = @Name
        WHERE   AccountEmployeeID = @ID;

      END;

      BEGIN --Fix t_GymMemberAttendance

        UPDATE  Gym.t_GymMemberAttendance
        SET     Account = @Name
        WHERE   AccountID = @ID;

      END;
	  
      BEGIN --Fix t_CarExpense

        UPDATE  Cars.t_CarExpense
        SET     FromAccount = @Name
        WHERE   FromAccountID = @ID;

        UPDATE  Cars.t_CarExpense
        SET     ToAccount = @Name
        WHERE   ToAccountID = @ID;

        UPDATE  Cars.t_CarExpense
        SET     VendorAccount = @Name
        WHERE   VendorAccountID = @ID;

      END;
    
      BEGIN --Fix t_CarRental

        UPDATE  Cars.t_CarRental
        SET     Account = @Name
        WHERE   AccountID = @ID;

        UPDATE  Cars.t_CarRentalHistory
        SET     Account = @Name
        WHERE   AccountID = @ID;
    
        UPDATE  Cars.t_CarRental
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @ID;

        UPDATE  Cars.t_CarRentalHistory
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @ID;

      END;

      ENABLE TRIGGER Company.tr_Account ON Company.t_Account;
      ENABLE TRIGGER Invoices.tr_Sold ON Invoices.t_Sold;
      ENABLE TRIGGER Invoices.tr_SoldReturn ON Invoices.t_SoldReturn;
      ENABLE TRIGGER Invoices.tr_Purchasing ON Invoices.t_Purchasing;
      ENABLE TRIGGER Invoices.tr_PurchasingReturn ON Invoices.t_PurchasingReturn;
      ENABLE TRIGGER Transactions.tr_TransactionDetail ON Transactions.t_TransactionDetail;

    END;

    IF @CurrencyIDOld <> @CurrencyID
    BEGIN; --Fix Balance

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
      WHERE   ID = @ID;

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
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

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
