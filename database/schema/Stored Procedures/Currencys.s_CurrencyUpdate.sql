SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Currencys].[s_CurrencyUpdate]
  @Name NVARCHAR(450) ,
  @ExchangeRate DECIMAL(18, 2) ,
  @ExchangeRateTax DECIMAL(18, 2) ,
  @DecimalNumber TINYINT ,
  @PositivePattern TINYINT ,
  @DescriptionAR NVARCHAR(MAX) ,
  @DescriptionEN NVARCHAR(MAX) ,
  @DescriptionDecimalAR NVARCHAR(MAX) ,
  @DescriptionDecimalEN NVARCHAR(MAX) ,
  @RewardPointsInsteadOf FLOAT ,
  @MinimumUnit FLOAT ,
  @RoundingAfter FLOAT ,
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
        @ExchangeRateOld DECIMAL(18, 2) ,
        @TypeIs INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name ,
              @ExchangeRateOld = s.ExchangeRate ,
              @TypeIs = s.TypeIs
      FROM    Currencys.t_Currency AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Currencys.t_Currency
      SET     Name = @Name ,
              ExchangeRate = @ExchangeRate ,
              ExchangeRateTax = @ExchangeRateTax ,
              DecimalNumber = @DecimalNumber ,
              PositivePattern = @PositivePattern ,
              DescriptionAR = @DescriptionAR ,
              DescriptionEN = @DescriptionEN ,
              DescriptionDecimalAR = @DescriptionDecimalAR ,
              DescriptionDecimalEN = @DescriptionDecimalEN ,
              RewardPointsInsteadOf = @RewardPointsInsteadOf ,
              MinimumUnit = @MinimumUnit ,
              RoundingAfter = @RoundingAfter
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Currencys.t_CurrencyMoving
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

      BEGIN --t_ItemShared

        UPDATE  Items.t_ItemShared
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_UnityItem

        UPDATE  Items.t_UnityItem
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

        UPDATE  Items.t_UnityItem
        SET     CurrencyCost = @Name
        WHERE   CurrencyIDCost = @ID;

      END;

      BEGIN --t_Account

        UPDATE  Company.t_Account
        SET     Currency = @Name ,
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
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_TransferAwaited, t_Transfer

        UPDATE  Invoices.t_TransferAwaited
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

        UPDATE  Invoices.t_Transfer
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN; --t_Purchasing

        DISABLE TRIGGER Invoices.tr_Purchasing ON Invoices.t_Purchasing;

        UPDATE  Invoices.t_Purchasing
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

        ENABLE TRIGGER Invoices.tr_Purchasing ON Invoices.t_Purchasing;

      END;

      BEGIN; --t_PurchasingReturn

        DISABLE TRIGGER Invoices.tr_PurchasingReturn ON Invoices.t_PurchasingReturn;

        UPDATE  Invoices.t_PurchasingReturn
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

        ENABLE TRIGGER Invoices.tr_PurchasingReturn ON Invoices.t_PurchasingReturn;

      END;

      BEGIN; --t_Sold

        DISABLE TRIGGER Invoices.tr_Sold ON Invoices.t_Sold;

        UPDATE  Invoices.t_Sold
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

        ENABLE TRIGGER Invoices.tr_Sold ON Invoices.t_Sold;

      END;

      BEGIN; --t_SoldReturn

        DISABLE TRIGGER Invoices.tr_SoldReturn ON Invoices.t_SoldReturn;

        UPDATE  Invoices.t_SoldReturn
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

        ENABLE TRIGGER Invoices.tr_SoldReturn ON Invoices.t_SoldReturn;

      END;

      BEGIN --t_TransactionDetail

        UPDATE  Transactions.t_TransactionDetail
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_AccountGroup

        UPDATE  Company.t_AccountGroup
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_Employee

        UPDATE  Employees.t_Employee
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_Discount

        UPDATE  Employees.t_Discount
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_DiscountHistory

        UPDATE  Employees.t_DiscountHistory
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_Bonus

        UPDATE  Employees.t_Bonus
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_BonusHistory

        UPDATE  Employees.t_BonusHistory
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_BeginningInventoryQuantity

        UPDATE  Items.t_BeginningInventoryQuantity
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_VendorSchedulePayment

        UPDATE  Vendors.t_VendorSchedulePayment
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_Cheque

        UPDATE  Company.t_Cheque
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_ChequeHistory

        UPDATE  Company.t_ChequeHistory
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_Bond

        UPDATE  Company.t_Bond
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_BondHistory

        UPDATE  Company.t_BondHistory
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_AccountItemPrice

        UPDATE  Company.t_AccountItemPrice
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_CloseBox

        UPDATE  Company.t_CloseBox
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

        UPDATE  Company.t_CloseBoxDetail
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_Expense

        UPDATE  Company.t_Expense
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_OpenBox

        UPDATE  Company.t_OpenBox
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_StockAdjustment

        UPDATE  Items.t_StockAdjustment
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_StockTake

        UPDATE  Items.t_StockTake
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_InternetPackage

        UPDATE  Customers.t_InternetPackage
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_InternetSubscription

        UPDATE  Invoices.t_InternetSubscription
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_Customer

        UPDATE  Customers.t_Customer
        SET     MaximumDebtInvoiceCurrency = @Name
        WHERE   MaximumDebtInvoiceCurrencyID = @ID;

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
                     WHERE  s1.CurrencyID = @ID
                   )
          UPDATE  o
          SET     o.InternetSubscriptionTotalF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionTotal) ,
                  o.InternetSubscriptionProfitF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionProfit) ,
                  o.FrameJobOrderTotalF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderTotal) ,
                  o.FrameJobOrderProfitF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderProfit);

      END;
	    
      BEGIN; --t_DeliveryService

        UPDATE  Invoices.t_DeliveryService
        SET     CostCurrency = @Name
        WHERE   CostCurrencyID = @ID;

        UPDATE  Invoices.t_DeliveryServiceHistory
        SET     CostCurrency = @Name
        WHERE   CostCurrencyID = @ID;

        UPDATE  Invoices.t_DeliveryServiceDeleted
        SET     CostCurrency = @Name
        WHERE   CostCurrencyID = @ID;

        UPDATE  Invoices.t_DeliveryService
        SET     DeliveryChargeCurrency = @Name
        WHERE   DeliveryChargeCurrencyID = @ID;

        UPDATE  Invoices.t_DeliveryServiceHistory
        SET     DeliveryChargeCurrency = @Name
        WHERE   DeliveryChargeCurrencyID = @ID;

        UPDATE  Invoices.t_DeliveryServiceDeleted
        SET     DeliveryChargeCurrency = @Name
        WHERE   DeliveryChargeCurrencyID = @ID;

      END;
	    
      BEGIN; --t_ItemExpirationDate

        UPDATE  Items.t_ItemExpirationDate
        SET     Currency = @Name ,
                PriceF = Currencys.f_Format(@ID, Price)
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_FrameJobOrder

        UPDATE  Customers.t_FrameJobOrder
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --t_FrameJobOrderHistory

        UPDATE  Customers.t_FrameJobOrderHistory
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;
       
      END;
   
      BEGIN --t_SubscriptionType

        UPDATE  Gym.t_SubscriptionType
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;
   
      BEGIN --t_PersonalTrainer

        UPDATE  Gym.t_PersonalTrainer
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;
  
      BEGIN --t_GymClass

        UPDATE  Gym.t_GymClass
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;
    
      BEGIN --t_GymSubscription

        UPDATE  Gym.t_GymSubscription
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

        UPDATE  Gym.t_GymSubscriptionHistory
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

        UPDATE  Gym.t_GymSubscriptionDeleted
        SET     Currency = @Name
        WHERE   CurrencyID = @ID;

      END;

      BEGIN --Cars

        UPDATE  Cars.t_Car
        SET     Currency = @Name ,
                PurchasePriceF = Currencys.f_Format(CurrencyID, PurchasePrice) ,
                SalePriceF = Currencys.f_Format(CurrencyID, SalePrice) ,
                DayPriceF = Currencys.f_Format(CurrencyID, DayPrice) ,
                WeekPriceF = Currencys.f_Format(CurrencyID, WeekPrice) ,
                MonthPriceF = Currencys.f_Format(CurrencyID, MonthPrice)
        WHERE   CurrencyID = @ID;
    
	    UPDATE  Cars.t_CarExpense
        SET     Currency = @Name ,
                BalanceF = Currencys.f_Format(CurrencyID, Balance) ,
                TaxValueF = Currencys.f_Format(CurrencyID, TaxValue) ,
                NetIsF = Currencys.f_Format(CurrencyID, NetIs)
        WHERE   CurrencyID = @ID;
	
	    UPDATE  Cars.t_CarRental
        SET     Currency = @Name ,
                DayPriceF = Currencys.f_Format(CurrencyID, DayPrice) ,
                DayTotalPriceF = Currencys.f_Format(CurrencyID, DayTotalPrice) ,
                WeekPriceF = Currencys.f_Format(CurrencyID, WeekPrice) ,
                WeekTotalPriceF = Currencys.f_Format(CurrencyID, WeekTotalPrice) ,
                MonthPriceF = Currencys.f_Format(CurrencyID, MonthPrice) ,
                MonthTotalPriceF = Currencys.f_Format(CurrencyID, MonthTotalPrice) ,
                SubtotalF = Currencys.f_Format(CurrencyID, Subtotal) ,
                DiscountF = Currencys.f_Format(CurrencyID, Discount) ,
                TotalF = Currencys.f_Format(CurrencyID, Total) ,
                FirstPaymentF = Currencys.f_Format(CurrencyID, FirstPayment) ,
                PaidUpF = Currencys.f_Format(CurrencyID, PaidUp) ,
                RestF = Currencys.f_Format(CurrencyID, Rest) ,
                DailyTaxF = Currencys.f_Format(CurrencyID, DailyTax) ,
                TotalTaxF = Currencys.f_Format(CurrencyID, TotalTax) ,
                ProfitF = Currencys.f_Format(CurrencyID, Profit)
        WHERE   CurrencyID = @ID;
	
	    UPDATE  Cars.t_CarRentalHistory
        SET     Currency = @Name ,
                DayPriceF = Currencys.f_Format(CurrencyID, DayPrice) ,
                DayTotalPriceF = Currencys.f_Format(CurrencyID, DayTotalPrice) ,
                WeekPriceF = Currencys.f_Format(CurrencyID, WeekPrice) ,
                WeekTotalPriceF = Currencys.f_Format(CurrencyID, WeekTotalPrice) ,
                MonthPriceF = Currencys.f_Format(CurrencyID, MonthPrice) ,
                MonthTotalPriceF = Currencys.f_Format(CurrencyID, MonthTotalPrice) ,
                SubtotalF = Currencys.f_Format(CurrencyID, Subtotal) ,
                DiscountF = Currencys.f_Format(CurrencyID, Discount) ,
                TotalF = Currencys.f_Format(CurrencyID, Total) ,
                FirstPaymentF = Currencys.f_Format(CurrencyID, FirstPayment) ,
                PaidUpF = Currencys.f_Format(CurrencyID, PaidUp) ,
                RestF = Currencys.f_Format(CurrencyID, Rest) ,
                DailyTaxF = Currencys.f_Format(CurrencyID, DailyTax) ,
                TotalTaxF = Currencys.f_Format(CurrencyID, TotalTax) ,
                ProfitF = Currencys.f_Format(CurrencyID, Profit)
        WHERE   CurrencyID = @ID;

      END;

    END;

    IF @ExchangeRateOld <> @ExchangeRate
    BEGIN --Fix

      BEGIN; --t_ItemShared

        WITH  o AS ( SELECT s.CurrencyID ,
                            s.Purchase ,
                            s.PurchaseD ,
                            s.PurchaseLL ,
                            s.PurchaseEuro ,
                            s.PurchaseWithTax ,
                            s.PurchaseWithTaxD ,
                            s.PurchaseWithTaxLL ,
                            s.PurchaseWithTaxEuro ,
                            s.SellCurrencyID ,
                            s.Sell ,
                            s.SellD ,
                            s.SellLL ,
                            s.SellEuro ,
                            s.SellWithTax ,
                            s.SellWithTaxD ,
                            s.SellWithTaxLL ,
                            s.SellWithTaxEuro ,
                            s1.ExchangeRate ,
                            s2.ExchangeRate AS ExchangeRateSell
                     FROM   Items.t_ItemShared AS s
                     LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
                     LEFT JOIN Currencys.t_Currency AS s2 ON s2.ID = s.SellCurrencyID
                   )
          UPDATE  o
          SET     o.PurchaseD = o.Purchase / o.ExchangeRate ,
                  o.PurchaseLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.Purchase, o.Purchase / o.ExchangeRate) ,
                  o.PurchaseEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.Purchase, o.Purchase / o.ExchangeRate) ,
                  o.PurchaseWithTaxD = o.PurchaseWithTax / o.ExchangeRate ,
                  o.PurchaseWithTaxLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.PurchaseWithTax, o.PurchaseWithTax / o.ExchangeRate) ,
                  o.PurchaseWithTaxEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.PurchaseWithTax, o.PurchaseWithTax / o.ExchangeRate) ,
                  o.SellD = o.Sell / o.ExchangeRateSell ,
                  o.SellLL = Currencys.f_ExchangeToLL(o.SellCurrencyID, o.Sell, o.Sell / o.ExchangeRateSell) ,
                  o.SellEuro = Currencys.f_ExchangeToEuro(o.SellCurrencyID, o.Sell, o.Sell / o.ExchangeRateSell) ,
                  o.SellWithTaxD = o.SellWithTax / o.ExchangeRateSell ,
                  o.SellWithTaxLL = Currencys.f_ExchangeToLL(o.SellCurrencyID, o.SellWithTax, o.SellWithTax / o.ExchangeRateSell) ,
                  o.SellWithTaxEuro = Currencys.f_ExchangeToEuro(o.SellCurrencyID, o.SellWithTax, o.SellWithTax / o.ExchangeRateSell);

        UPDATE  Items.t_ItemShared
        SET     PurchaseTotalF = Currencys.f_Format(CurrencyID, Purchase * QtyCurrent) ,
                PurchaseTotalD = PurchaseD * QtyCurrent ,
                PurchaseTotalLL = PurchaseLL * QtyCurrent ,
                PurchaseTotalEuro = PurchaseEuro * QtyCurrent ,
                PurchaseTotalWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax * QtyCurrent) ,
                PurchaseTotalWithTaxD = PurchaseWithTaxD * QtyCurrent ,
                PurchaseTotalWithTaxLL = PurchaseWithTaxLL * QtyCurrent ,
                PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent ,
                SellTotalF = Currencys.f_Format(SellCurrencyID, Sell * QtyCurrent) ,
                SellTotalD = SellD * QtyCurrent ,
                SellTotalLL = SellLL * QtyCurrent ,
                SellTotalEuro = SellEuro * QtyCurrent ,
                SellTotalWithTaxF = Currencys.f_Format(SellCurrencyID, SellWithTax * QtyCurrent) ,
                SellTotalWithTaxD = SellWithTaxD * QtyCurrent ,
                SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent ,
                SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent;

      END;

      BEGIN; --t_ItemExpirationDate
			
        WITH  o AS ( SELECT s.Price ,
                            s.PriceD ,
                            s.PriceLL ,
                            s.PriceEuro ,
                            s.CurrencyID ,
                            s1.ExchangeRate
                     FROM   Items.t_ItemExpirationDate AS s
                     LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
                   )
          UPDATE  o
          SET     o.PriceD = o.Price / o.ExchangeRate ,
                  o.PriceLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.Price, o.Price / o.ExchangeRate) ,
                  o.PriceEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.Price, o.Price / o.ExchangeRate);

      END;

      BEGIN; --t_SubscriptionType
			
        WITH  o AS ( SELECT s.Price ,
                            s.PriceD ,
                            s.PriceLL ,
                            s.PriceEuro ,
                            s.CurrencyID ,
                            s1.ExchangeRate
                     FROM   Gym.t_SubscriptionType AS s
                     LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
                   )
          UPDATE  o
          SET     o.PriceD = o.Price / o.ExchangeRate ,
                  o.PriceLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.Price, o.Price / o.ExchangeRate) ,
                  o.PriceEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.Price, o.Price / o.ExchangeRate);

      END;
   
      BEGIN; --t_PersonalTrainer
			
        WITH  o AS ( SELECT s.Price ,
                            s.PriceD ,
                            s.PriceLL ,
                            s.PriceEuro ,
                            s.CurrencyID ,
                            s1.ExchangeRate
                     FROM   Gym.t_PersonalTrainer AS s
                     LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
                   )
          UPDATE  o
          SET     o.PriceD = o.Price / o.ExchangeRate ,
                  o.PriceLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.Price, o.Price / o.ExchangeRate) ,
                  o.PriceEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.Price, o.Price / o.ExchangeRate);

      END;
   
      BEGIN; --t_GymClass
			
        WITH  o AS ( SELECT s.PriceDaily ,
                            s.PriceDailyD ,
                            s.PriceDailyLL ,
                            s.PriceDailyEuro ,
                            s.PriceWeekly ,
                            s.PriceWeeklyD ,
                            s.PriceWeeklyLL ,
                            s.PriceWeeklyEuro ,
                            s.PriceMonthly ,
                            s.PriceMonthlyD ,
                            s.PriceMonthlyLL ,
                            s.PriceMonthlyEuro ,
                            s.SalaryDaily ,
                            s.SalaryDailyD ,
                            s.SalaryDailyLL ,
                            s.SalaryDailyEuro ,
                            s.SalaryWeekly ,
                            s.SalaryWeeklyD ,
                            s.SalaryWeeklyLL ,
                            s.SalaryWeeklyEuro ,
                            s.SalaryMonthly ,
                            s.SalaryMonthlyD ,
                            s.SalaryMonthlyLL ,
                            s.SalaryMonthlyEuro ,
                            s.CurrencyID ,
                            s1.ExchangeRate
                     FROM   Gym.t_GymClass AS s
                     LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
                   )
          UPDATE  o
          SET     o.PriceDailyD = o.PriceDaily / o.ExchangeRate ,
                  o.PriceDailyLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.PriceDaily, o.PriceDaily / o.ExchangeRate) ,
                  o.PriceDailyEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.PriceDaily, o.PriceDaily / o.ExchangeRate) ,
                  o.PriceWeeklyD = o.PriceWeekly / o.ExchangeRate ,
                  o.PriceWeeklyLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.PriceWeekly, o.PriceWeekly / o.ExchangeRate) ,
                  o.PriceWeeklyEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.PriceWeekly, o.PriceWeekly / o.ExchangeRate) ,
                  o.PriceMonthlyD = o.PriceMonthly / o.ExchangeRate ,
                  o.PriceMonthlyLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.PriceMonthly, o.PriceMonthly / o.ExchangeRate) ,
                  o.PriceMonthlyEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.PriceMonthly, o.PriceMonthly / o.ExchangeRate) ,
                  o.SalaryDailyD = o.SalaryDaily / o.ExchangeRate ,
                  o.SalaryDailyLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.SalaryDaily, o.SalaryDaily / o.ExchangeRate) ,
                  o.SalaryDailyEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.SalaryDaily, o.SalaryDaily / o.ExchangeRate) ,
                  o.SalaryWeeklyD = o.SalaryWeekly / o.ExchangeRate ,
                  o.SalaryWeeklyLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.SalaryWeekly, o.SalaryWeekly / o.ExchangeRate) ,
                  o.SalaryWeeklyEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.SalaryWeekly, o.SalaryWeekly / o.ExchangeRate) ,
                  o.SalaryMonthlyD = o.SalaryMonthly / o.ExchangeRate ,
                  o.SalaryMonthlyLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.SalaryMonthly, o.SalaryMonthly / o.ExchangeRate) ,
                  o.SalaryMonthlyEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.SalaryMonthly, o.SalaryMonthly / o.ExchangeRate);

      END;

      BEGIN; --t_Car
			
        WITH  o AS ( SELECT s.PurchasePrice ,
                            s.PurchasePriceD ,
                            s.PurchasePriceLL ,
                            s.PurchasePriceEuro ,
                            s.SalePrice ,
                            s.SalePriceD ,
                            s.SalePriceLL ,
                            s.SalePriceEuro ,
                            s.DayPrice ,
                            s.DayPriceD ,
                            s.DayPriceLL ,
                            s.DayPriceEuro ,
                            s.WeekPrice ,
                            s.WeekPriceD ,
                            s.WeekPriceLL ,
                            s.WeekPriceEuro ,
                            s.MonthPrice ,
                            s.MonthPriceD ,
                            s.MonthPriceLL ,
                            s.MonthPriceEuro ,
                            s.CurrencyID ,
                            s1.ExchangeRate
                     FROM   Cars.t_Car AS s
                     INNER JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
                   )
          UPDATE  o
          SET     o.PurchasePriceD = o.PurchasePrice / o.ExchangeRate ,
                  o.PurchasePriceLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.PurchasePrice, o.PurchasePrice / o.ExchangeRate) ,
                  o.PurchasePriceEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.PurchasePrice, o.PurchasePrice / o.ExchangeRate) ,
                  o.SalePriceD = o.SalePrice / o.ExchangeRate ,
                  o.SalePriceLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.SalePrice, o.SalePrice / o.ExchangeRate) ,
                  o.SalePriceEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.SalePrice, o.SalePrice / o.ExchangeRate) ,
                  o.DayPriceD = o.DayPrice / o.ExchangeRate ,
                  o.DayPriceLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.DayPrice, o.DayPrice / o.ExchangeRate) ,
                  o.DayPriceEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.DayPrice, o.DayPrice / o.ExchangeRate) ,
                  o.WeekPriceD = o.WeekPrice / o.ExchangeRate ,
                  o.WeekPriceLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.WeekPrice, o.WeekPrice / o.ExchangeRate) ,
                  o.WeekPriceEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.WeekPrice, o.WeekPrice / o.ExchangeRate) ,
                  o.MonthPriceD = o.MonthPrice / o.ExchangeRate ,
                  o.MonthPriceLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.MonthPrice, o.MonthPrice / o.ExchangeRate) ,
                  o.MonthPriceEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.MonthPrice, o.MonthPrice / o.ExchangeRate);

      END;

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
