SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountRebuildingStatistics]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    DISABLE TRIGGER Company.tr_Account ON Company.t_Account;
    DISABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
    DISABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
    DISABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;

    BEGIN --Rebuilding statistics

      SET @Return = 0;

      UPDATE  Company.t_Account
      SET     Level3 = Company.f_AccountLevel3GetName(Level3ID) ,
              NumberNet = SUBSTRING(NumberF, 6, 5) ,
              Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
              BalanceF = Currencys.f_Format(CurrencyID, Balance) ,
              BalanceD = COALESCE(( SELECT  SUM(t.BalanceD)
                                    FROM    Transactions.t_TransactionDetail AS t
                                    WHERE   t.AccountID = t_Account.ID
                                  ), 0) ,
              BalanceLL = COALESCE(( SELECT SUM(t.BalanceLL)
                                     FROM   Transactions.t_TransactionDetail AS t
                                     WHERE  t.AccountID = t_Account.ID
                                   ), 0) ,
              BalanceEuro = COALESCE(( SELECT SUM(t.BalanceEuro)
                                       FROM   Transactions.t_TransactionDetail AS t
                                       WHERE  t.AccountID = t_Account.ID
                                     ), 0) ,
              LimitF = Currencys.f_Format(CurrencyID, Limit) ,
              LimitD = Currencys.f_ExchangeToDollarBy(CurrencyID, Limit) ,
              UserBlockedC = ( SELECT COUNT(*)
                               FROM   Company.t_AccountUserBlocked AS s
                               WHERE  s.AccountID = t_Account.ID
                             ) ,
              UsersNames = Alls.f_FixXML(( SELECT ', ' + t1.Name AS [text()]
                                           FROM   Company.t_AccountUserBlocked AS t
                                           LEFT JOIN Users.t_User AS t1 ON t1.ID = t.UserID
                                           WHERE  t.AccountID = t_Account.ID
                                         FOR
                                           XML PATH('')
                                         )) ,
              AccountMergeC = ( SELECT  COUNT(*)
                                FROM    Company.t_AccountMerge AS s
                                WHERE   s.AccountID = t_Account.ID
                              ) ,
              AccountMergeNames = Alls.f_FixXML(( SELECT  ', ' + t1.Name AS [text()]
                                                  FROM    Company.t_AccountMerge AS t
                                                  LEFT JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
                                                  WHERE   t.AccountID = t_Account.ID
                                                FOR
                                                  XML PATH('')
                                                )) ,
              DeliveryServicesC = [Invoices].f_DeliveryServiceGetCountByAccountCustomerID(ID) ,
              DeliveryServicesTotal = [Invoices].[f_DeliveryServiceGetTotalByAccountCustomerID](ID) ,
              DeliveryServicesProfit = [Invoices].[f_DeliveryServiceGetProfitByAccountCustomerID](ID) ,
              DeliveryServicesLastDate = [Invoices].f_DeliveryServiceGetLastDateByAccountCustomerID(ID) ,
              PurchasingC = [Invoices].[f_PurchasingGetCountByAccountVendorID](ID) ,
              PurchasingTotal = [Invoices].[f_PurchasingGetTotalByAccountVendorID](ID) ,
              PurchasingProfit = [Invoices].[f_PurchasingGetProfitByAccountVendorID](ID) ,
              PurchasingLast = [Invoices].[f_PurchasingGetLastDateByAccountVendorID](ID) ,
              PurchasingReturnC = [Invoices].[f_PurchasingReturnGetCountByAccountVendorID](ID) ,
              PurchasingReturnTotal = [Invoices].[f_PurchasingReturnGetTotalByAccountVendorID](ID) ,
              PurchasingReturnProfit = [Invoices].[f_PurchasingReturnGetProfitByAccountVendorID](ID) ,
              PurchasingReturnLast = [Invoices].[f_PurchasingReturnGetLastDateByAccountVendorID](ID) ,
              SoldC = [Invoices].[f_SoldGetCountByAccountCustomerID](ID) ,
              SoldTotal = [Invoices].[f_SoldGetTotalByAccountCustomerID](ID) ,
              SoldProfit = [Invoices].[f_SoldGetProfitByAccountCustomerID](ID) ,
              SoldLast = [Invoices].[f_SoldGetLastDateByAccountCustomerID](ID) ,
              SoldReturnC = [Invoices].[f_SoldReturnGetCountByAccountCustomerID](ID) ,
              SoldReturnTotal = [Invoices].[f_SoldReturnGetTotalByAccountCustomerID](ID) ,
              SoldReturnProfit = [Invoices].[f_SoldReturnGetProfitByAccountCustomerID](ID) ,
              SoldReturnLast = [Invoices].[f_SoldReturnGetLastDateByAccountCustomerID](ID) ,
              QuotationC = Quotations.[f_QuotationGetCountByAccountID](ID) ,
              QuotationTotal = Quotations.[f_QuotationGetTotalByAccountID](ID) ,
              QuotationProfit = Quotations.[f_QuotationGetProfitByAccountID](ID) ,
              QuotationLast = Quotations.[f_QuotationGetLastDateByAccountID](ID) ,
              GymSubscriptionC = [Gym].f_GymSubscriptionGetCountByAccountID(ID) ,
              GymSubscriptionLast = [Gym].f_GymSubscriptionGetLastByAccountID(ID) ,
              GymSubscriptionTotal = [Gym].[f_GymSubscriptionGetTotalByAccountID](ID) ,
              GymSubscriptionProfit = [Gym].[f_GymSubscriptionGetProfitByAccountID](ID) ,
              GymSubscriptionActiveTo = [Gym].f_GymSubscriptionGetActiveToByAccountID(ID);

      UPDATE  Company.t_Account
      SET     DeliveryServicesTotalF = Currencys.f_Format(CurrencyID, DeliveryServicesTotal) ,
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
              GymSubscriptionProfitF = Currencys.f_Format(CurrencyID, GymSubscriptionProfit) ,
              GymSubscriptionIsActive = IIF(GymSubscriptionActiveTo >= CONVERT(DATE, GETDATE()), 1, 0);

      UPDATE  Company.t_AccountLevel3
      SET     Level2 = Company.f_AccountLevel2GetName(Level2ID) ,
              BalanceD = COALESCE(( SELECT  SUM(t.BalanceD)
                                    FROM    Company.t_Account AS t
                                    WHERE   t.Level3ID = t_AccountLevel3.ID
                                  ), 0) ,
              BalanceLL = COALESCE(( SELECT SUM(t.BalanceLL)
                                     FROM   Company.t_Account AS t
                                     WHERE  t.Level3ID = t_AccountLevel3.ID
                                   ), 0) ,
              BalanceEuro = COALESCE(( SELECT SUM(t.BalanceEuro)
                                       FROM   Company.t_Account AS t
                                       WHERE  t.Level3ID = t_AccountLevel3.ID
                                     ), 0);

      UPDATE  Company.t_AccountLevel2
      SET     Level1 = Company.f_AccountLevel2GetName(Level1ID) ,
              BalanceD = COALESCE(( SELECT  SUM(t.BalanceD)
                                    FROM    Company.t_AccountLevel3 AS t
                                    WHERE   t.Level2ID = t_AccountLevel2.ID
                                  ), 0) ,
              BalanceLL = COALESCE(( SELECT SUM(t.BalanceLL)
                                     FROM   Company.t_AccountLevel3 AS t
                                     WHERE  t.Level2ID = t_AccountLevel2.ID
                                   ), 0) ,
              BalanceEuro = COALESCE(( SELECT SUM(t.BalanceEuro)
                                       FROM   Company.t_AccountLevel3 AS t
                                       WHERE  t.Level2ID = t_AccountLevel2.ID
                                     ), 0);

      UPDATE  Company.t_AccountLevel1
      SET     BalanceD = COALESCE(( SELECT  SUM(t.BalanceD)
                                    FROM    Company.t_AccountLevel2 AS t
                                    WHERE   t.Level1ID = t_AccountLevel1.ID
                                  ), 0) ,
              BalanceLL = COALESCE(( SELECT SUM(t.BalanceLL)
                                     FROM   Company.t_AccountLevel2 AS t
                                     WHERE  t.Level1ID = t_AccountLevel1.ID
                                   ), 0) ,
              BalanceEuro = COALESCE(( SELECT SUM(t.BalanceEuro)
                                       FROM   Company.t_AccountLevel2 AS t
                                       WHERE  t.Level1ID = t_AccountLevel1.ID
                                     ), 0);

      UPDATE  Company.t_Account
      SET     SearchText = Company.f_AccountSearchTextGet(ID);
      
      UPDATE  Company.t_AccountLevel1
      SET     SearchText = Company.f_AccountLevel1SearchTextGet(ID);
      
      UPDATE  Company.t_AccountLevel2
      SET     SearchText = Company.f_AccountLevel2SearchTextGet(ID);
      
      UPDATE  Company.t_AccountLevel3
      SET     SearchText = Company.f_AccountLevel3SearchTextGet(ID);

    END;

    BEGIN --levels

      UPDATE  Company.t_AccountLevel2
      SET     Level1 = Company.f_AccountLevel1GetName(Level1ID) ,
              NumberNet = SUBSTRING(NumberF, 3, 1);

      UPDATE  Company.t_AccountLevel3
      SET     Level2 = Company.f_AccountLevel2GetName(Level2ID) ,
              NumberNet = SUBSTRING(NumberF, 4, 2);

    END;

    ENABLE TRIGGER Company.tr_Account ON Company.t_Account;
    ENABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
    ENABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
    ENABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;

    BEGIN --Account Blocked

      UPDATE  Company.t_AccountUserBlocked
      SET     Account = Company.f_AccountGetName(AccountID);

    END;

    BEGIN --Account Merge

      UPDATE  Company.t_AccountMerge
      SET     Account = Company.f_AccountGetName(AccountID) ,
              AccountWith = Company.f_AccountGetName(AccountIDWith);

        --UPDATE Company.t_AccountMerge
        --SET AccountNumber = Company.f_AccountGetNumber(AccountID),
        --    AccountNumberF = Company.f_AccountGetNumberF(AccountID),
        --    AccountWithNumber = Company.f_AccountGetNumber(AccountIDWith),
        --    AccountWithNumberF = Company.f_AccountGetNumberF(AccountIDWith);

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
                '00000000-0000-0000-0000-000000000000' ,
                @Event ,
                6 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    COMMIT TRAN;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;
END;








GO
