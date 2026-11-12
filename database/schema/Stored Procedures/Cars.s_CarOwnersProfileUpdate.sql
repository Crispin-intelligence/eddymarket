SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [Cars].[s_CarOwnersProfileUpdate]
  @Name NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @AccountCurrencyID UNIQUEIDENTIFIER ,
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

      DECLARE @AccountID UNIQUEIDENTIFIER ,
        @AccountCurrencyIDOld UNIQUEIDENTIFIER ,
        @NameOld NVARCHAR(450) ,
        @Return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Cars.t_CarOwnersProfile AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

      SELECT TOP ( 1 )
              @AccountID = s.ID ,
              @AccountCurrencyIDOld = s.CurrencyID
      FROM    Company.t_Account AS s
      WHERE   SectionID = 179
              AND LinkWithID = @ID
              AND s.IsMasterLink = 1
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Cars.t_CarOwnersProfile
      SET     Name = @Name ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarOwnersProfileMoving
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
    BEGIN

      UPDATE  Company.t_Account
      SET     LinkWith = @Name ,
              Name = @Name
      WHERE   SectionID = 179
              AND IsMasterLink = 1
              AND LinkWithID = @ID;

      UPDATE  Cars.t_CarOwners
      SET     OwnerProfile = @Name
      WHERE   OwnerProfileID = @ID;
  
      UPDATE  Cars.t_CarRentalOwner
      SET     OwnerProfile = @Name
      WHERE   OwnerProfileID = @ID;
 
      UPDATE  Cars.t_CarRentalHistoryOwner
      SET     OwnerProfile = @Name
      WHERE   OwnerProfileID = @ID;

    END;

    IF @AccountCurrencyIDOld <> @AccountCurrencyID
    BEGIN; --Fix Balance

      UPDATE  Company.t_Account
      SET     CurrencyID = @AccountCurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@AccountCurrencyID) ,
              CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@AccountCurrencyID) ,
              IsSync = 0
      WHERE   SectionID = 179
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
      WHERE   SectionID = 179
              AND LinkWithID = @ID;

      UPDATE  Company.t_Account
      SET     BalanceF = Currencys.f_Format(@AccountCurrencyID, Balance) ,
              LimitF = Currencys.f_Format(@AccountCurrencyID, Limit) ,
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
      WHERE   SectionID = 179
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
