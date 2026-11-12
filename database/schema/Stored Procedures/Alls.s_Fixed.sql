SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_Fixed]
AS
BEGIN; --14-03-2022

  PRINT '';

  --UPDATE  Invoices.t_SoldDetail
  --SET     SearchText = Invoices.f_SoldDetailSearchTextGet(ID);

END;

BEGIN; --13-03-2022

  PRINT '';

  --UPDATE  Items.t_ItemExpirationDate
  --SET     SearchText = Items.f_ItemExpirationDateSearchTextGet(ID);

END;

BEGIN; --07-03-2022

  PRINT '';

  --UPDATE  Invoices.t_Sold
  --SET     SearchText = Invoices.f_SoldSearchTextGet(ID);
  
  --UPDATE  Invoices.t_InvoiceTitle
  --SET     SearchText = Invoices.f_InvoiceTitleSearchTextGet(ID);
  
  --UPDATE  Company.t_Doctor
  --SET     SearchText = Company.f_DoctorSearchTextGet(ID);

  --UPDATE  Customers.t_Prescription
  --SET     SearchText = Customers.f_PrescriptionSearchTextGet(ID);

  --UPDATE  Company.t_Bank
  --SET     SearchText = Company.f_BankSearchTextGet(ID);
 
  --UPDATE  Vendors.t_Vendor
  --SET     SearchText = Vendors.f_VendorSearchTextGet(ID);
	 
END;

BEGIN; --06-03-2022

  PRINT '';

  --DISABLE TRIGGER Company.tr_Account ON Company.t_Account;
  --DISABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
  --DISABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
  --DISABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;

  --UPDATE  Company.t_Account
  --SET     SearchText = Company.f_AccountSearchTextGet(ID);
      
  --UPDATE  Company.t_AccountLevel1
  --SET     SearchText = Company.f_AccountLevel1SearchTextGet(ID);
      
  --UPDATE  Company.t_AccountLevel2
  --SET     SearchText = Company.f_AccountLevel2SearchTextGet(ID);
      
  --UPDATE  Company.t_AccountLevel3
  --SET     SearchText = Company.f_AccountLevel3SearchTextGet(ID);

  --ENABLE TRIGGER Company.tr_Account ON Company.t_Account;
  --ENABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
  --ENABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
  --ENABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;

END;

BEGIN; --03-03-2022

  PRINT '';

  --UPDATE  Invoices.t_Sold
  --SET     SaveFrom = 2
  --WHERE   FrameJobOrderID <> '00000000-0000-0000-0000-000000000000';

  --UPDATE  Invoices.t_SoldDeleted
  --SET     SaveFrom = 2
  --WHERE   FrameJobOrderID <> '00000000-0000-0000-0000-000000000000';
   
END;

BEGIN; --28-02-2022

  PRINT '';

  --UPDATE  Employees.t_Employee
  --SET     SearchText = Employees.f_EmployeeSearchTextGet(ID);
	  
END;

BEGIN; --20-02-2022

  PRINT '';

  --WITH  o AS ( SELECT s.OrderBy ,
  --                    ROW_NUMBER() OVER ( ORDER BY Name ) AS NewOrderBy
  --             FROM   Items.t_MainCategory AS s
  --           )
  --  UPDATE  o
  --  SET     o.OrderBy = o.NewOrderBy;

  --WITH  o AS ( SELECT s.OrderBy ,
  --                    ROW_NUMBER() OVER ( ORDER BY Name ) AS NewOrderBy
  --             FROM   Items.t_ItemShared AS s
  --           )
  --  UPDATE  o
  --  SET     o.OrderBy = o.NewOrderBy;

END;

BEGIN; --09-02-2022 , t_Account of t_CarOwnersProfile 

  PRINT '';

  --DECLARE @CurrencyIDLL UNIQUEIDENTIFIER = [Currencys].[f_CurrencyGetFirstIDLL]();
  --DECLARE @CurrencyLL NVARCHAR(MAX) = [Currencys].[f_CurrencyGetName](@CurrencyIDLL);
  --DECLARE @CurrencyTypeIsLL INT = [Currencys].[f_CurrencyGetTypeIs](@CurrencyIDLL);
  --DECLARE @UserID UNIQUEIDENTIFIER = Users.f_UserGetFirstID();
						
  --IF NOT EXISTS ( SELECT TOP ( 1 )
  --                        s.ID
  --                FROM    Company.t_AccountLevel3 AS s
  --                WHERE   s.NumberIs = 62696 )
  --BEGIN

  --  INSERT  [Company].[t_AccountLevel3]
  --          ( Level2ID ,
  --            NumberIs ,
  --            NumberF ,
  --            Name
  --          )
  --  VALUES  ( [Company].[f_AccountLevel2GetIDByNumber](626) ,
  --            62696 ,
  --            N'62696' ,
  --            N'عمولة مبيعات'
  --          );

  --END;
  	
  --DECLARE @Level3ID UNIQUEIDENTIFIER = [Company].[f_AccountLevel3GetIDByNumber](62696);
  --DECLARE @Level3 NVARCHAR(MAX) = Company.f_AccountLevel3GetName(@Level3ID);
  
  --DECLARE @NumberIs BIGINT;
		
  --SELECT  @NumberIs = COALESCE(MAX(t.NumberIs), 6269600000)
  --FROM    Company.t_Account AS t
  --WHERE   t.Level3ID = @Level3ID;  

  --DISABLE TRIGGER Company.tr_Account ON Company.t_Account;

  --INSERT  INTO Company.t_Account
  --        ( Level3ID ,
  --          Level3 ,
  --          SectionID ,
  --          LinkWithID ,
  --          LinkWith ,
  --          IsMasterLink ,
  --          NumberIs ,
  --          NumberF ,
  --          NumberNet ,
  --          Name ,
  --          CurrencyID ,
  --          Currency ,
  --          CurrencyTypeIs ,
  --          BalanceF ,
  --          LimitF ,
  --          IsStatic
  --        )
  --SELECT  @Level3ID ,
  --        @Level3 ,
  --        179 ,
  --        s.ID ,
  --        s.Name ,
  --        1 ,
  --        @NumberIs + ROW_NUMBER() OVER ( ORDER BY s.DateCreate ) ,
  --        @NumberIs + ROW_NUMBER() OVER ( ORDER BY s.DateCreate ) ,
  --        SUBSTRING(CONVERT(NVARCHAR(MAX), @NumberIs + ROW_NUMBER() OVER ( ORDER BY s.DateCreate )), 6, 5) ,
  --        s.Name ,
  --        @CurrencyIDLL ,
  --        @CurrencyLL ,
  --        @CurrencyTypeIsLL ,
  --        Currencys.f_Format(@CurrencyIDLL, 0) ,
  --        Currencys.f_Format(@CurrencyIDLL, 0) ,
  --        0
  --FROM    Cars.t_CarOwnersProfile AS s;

  --ENABLE TRIGGER Company.tr_Account ON Company.t_Account;
	
END;

BEGIN; --02-02-2022

  PRINT '';

  --UPDATE  Users.t_SettingPC
  --SET     CarRentalNewUIDailyTax = DEFAULT;

END;

BEGIN; --24-01-2022

  PRINT '';

  --INSERT  INTO Users.t_SettingPC2
  --        ( ID ,
  --          Computer 
  --        )
  --SELECT  s.ID ,
  --        s.Computer
  --FROM    Users.t_SettingPC AS s;

END;

BEGIN; --06-01-2022

  PRINT '';

   --EXECUTE Items.s_ProfitPartnerInsertDefaultData;

END;

BEGIN; --06-01-2022, t_User

  PRINT '';

  --UPDATE  Users.t_User
  --SET     AccountBoxLLID = AccountBoxID ,
  --        AccountBoxLLName = AccountBoxName ,
  --        AccountBoxLLNumberF = AccountBoxNumberF ,
  --        AccountBoxEuroID = AccountBoxID ,
  --        AccountBoxEuroName = AccountBoxName ,
  --        AccountBoxEuroNumberF = AccountBoxNumberF;

END;

BEGIN; --15-12-2021, t_LiveVersion

  PRINT '';

  --DELETE  FROM Alls.t_LiveVersion;

  --EXECUTE [Alls].[s_LiveVersionInsertDefaultData];

END;

BEGIN; --13-12-2021, t_SocialMediaType (SearchIndex)

  PRINT '';

  --UPDATE  Company.t_SocialMediaType
  --SET     SearchText = Company.f_SocialMediaTypeSearchTextGet(ID);
  
END;

BEGIN; --09-12-2021, t_WareHouseUser (SearchIndex)

  PRINT '';

  --UPDATE  Company.t_Place
  --SET     SearchText = Company.f_PlaceSearchTextGet(ID);

  --UPDATE  Company.t_WareHouseUser
  --SET     SearchText = Company.f_WareHouseUserSearchTextGet(ID);

END;

BEGIN; --08-12-2021, t_WareHouse (SearchIndex)

  PRINT '';

  --UPDATE  Company.t_WareHouse
  --SET     SearchText = Company.f_WareHouseSearchTextGet(ID);

END;

BEGIN; --27-11-2021, t_BookPhone (SearchIndex)

  PRINT '';

  --UPDATE  Alls.t_LanguageCode
  --SET     SearchText = Alls.f_LanguageCodeSearchTextGet(ID);

  --UPDATE  Company.t_BookPhone
  --SET     SearchText = Company.f_BookPhoneSearchTextGet(ID);
  
END;

BEGIN; --27-11-2021, t_SalesPerson (SearchIndex)

  PRINT '';

  --UPDATE  Employees.t_SalesPerson
  --SET     SearchText = Employees.f_SalesPersonSearchTextGet(ID);
  
END;

BEGIN; --19-11-2021, t_Item, t_UnityItem (SearchIndex)

  PRINT '';

  --UPDATE  Items.t_Item
  --SET     SearchText = Items.f_ItemSearchTextGet(ID);
  
  --UPDATE  Items.t_UnityItem
  --SET     SearchText = Items.f_UnityItemSearchTextGet(ID);
  
END;

BEGIN; --18-11-2021, t_ItemSharedVendor (SearchIndex)

  PRINT '';

  --UPDATE  Items.t_ItemSharedVendor
  --SET     SearchText = Items.f_ItemSharedVendorSearchTextGet(ID);
  
END;

BEGIN; --16-11-2021, t_EmployeeType, t_Nationality (SearchIndex)

  PRINT '';

  --UPDATE  Employees.t_EmployeeType
  --SET     SearchText = Employees.f_EmployeeTypeSearchTextGet(ID);
  
  --UPDATE  Employees.t_Nationality
  --SET     SearchText = Employees.f_NationalitySearchTextGet(ID);
  
END;

BEGIN; --15-11-2021, t_AgeRange, t_Classification, t_Title (SearchIndex)

  PRINT '';

  --UPDATE  Customers.t_AgeRange
  --SET     SearchText = Customers.f_AgeRangeSearchTextGet(ID);
  
  --UPDATE  Customers.t_Classification
  --SET     SearchText = Customers.f_ClassificationSearchTextGet(ID);
  
  --UPDATE  Customers.t_Title
  --SET     SearchText = Customers.f_TitleSearchTextGet(ID);

END;

BEGIN; --13-11-2021, t_Building, t_Floor, t_PostalCode, t_Region, t_States, t_Street (SearchIndex)

  PRINT '';

  --UPDATE  Location.t_Building
  --SET     SearchText = Location.f_BuildingSearchTextGet(ID);

  --UPDATE  Location.t_Floor
  --SET     SearchText = Location.f_FloorSearchTextGet(ID);

  --UPDATE  Location.t_PostalCode
  --SET     SearchText = Location.f_PostalCodeSearchTextGet(ID);

  --UPDATE  Location.t_Region
  --SET     SearchText = Location.f_RegionSearchTextGet(ID);

  --UPDATE  Location.t_States
  --SET     SearchText = Location.f_StatesSearchTextGet(ID);

  --UPDATE  Location.t_Street
  --SET     SearchText = Location.f_StreetSearchTextGet(ID);

END;

BEGIN; --10-11-2021, t_ItemShared (SearchIndex)

  PRINT '';

  --UPDATE  Items.t_ItemShared
  --SET     SearchText = Items.f_ItemSharedSearchTextGet(ID);

END;

BEGIN; --05-11-2021, t_Brand, t_Unity (SearchIndex)

  PRINT '';

  --UPDATE  Items.t_MainCategory
  --SET     SearchText = Items.f_MainCategorySearchTextGet(ID);
	  
  --UPDATE  Items.t_Brand
  --SET     SearchText = Items.f_BrandSearchTextGet(ID);
	  
  --UPDATE  Items.t_Unity
  --SET     SearchText = Items.f_UnitySearchTextGet(ID);
	  
END;

BEGIN; --24-10-2021, t_ItemShared (SearchIndex)

  PRINT '';

 -- DISABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;
 
 -- DECLARE @ID UNIQUEIDENTIFIER;

 -- DECLARE Items CURSOR FORWARD_ONLY
 -- FOR
 -- SELECT s.ID
 --   FROM Items.t_ItemShared AS s;

 -- OPEN Items;

 -- FETCH NEXT FROM Items INTO @ID;
 -- WHILE @@FETCH_STATUS = 0
 -- BEGIN
		
 --   DECLARE @SearchIndex Alls.td_String;

	--DELETE from @SearchIndex;

 --   INSERT INTO @SearchIndex
 --       ( Name
 --       )
 --     SELECT s.Name
 --       FROM Items.t_ItemShared AS s
 --       WHERE s.ID = @ID
 --     UNION
 --     SELECT s.BarCode
 --       FROM Items.t_ItemSharedBarCode AS s
 --       WHERE s.SharedID = @ID;

 --   UPDATE Items.t_ItemShared
 --     SET SearchIndex = Alls.f_ToSearchIndex(@SearchIndex)
 --     WHERE ID = @ID;

 --   FETCH NEXT FROM Items INTO @ID;
 -- END;

 -- CLOSE Items;

 -- DEALLOCATE Items;

 -- ENABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;

END;

BEGIN; --12-10-2021, t_GymSubscription, t_GymSubscriptionHistory

  PRINT '';

  --DISABLE TRIGGER Gym.tr_GymSubscription ON Gym.t_GymSubscription;
  --DISABLE TRIGGER Gym.tr_GymSubscriptionHistory ON Gym.t_GymSubscriptionHistory;

  --UPDATE Gym.t_GymSubscription
  --  SET TransactionDate = COALESCE(( SELECT TOP ( 1 ) s.DateIs
  --                                    FROM Transactions.t_Transaction AS s
  --                                    WHERE s.LinkType = 174 AND s.LinkID = t_GymSubscription.ID AND s.TypeIs = N'JV'
  --                                    ORDER BY s.DateCreate
  --                                 ), t_GymSubscription.DateCreate);
 
  --UPDATE Gym.t_GymSubscriptionHistory
  --  SET TransactionDate = COALESCE(( SELECT TOP ( 1 ) s.DateIs
  --                                    FROM Transactions.t_Transaction AS s
  --                                    WHERE s.LinkType = 174 AND s.LinkID = t_GymSubscriptionHistory.ID AND s.TypeIs = N'JV'
  --                                    ORDER BY s.DateCreate
  --                                 ), t_GymSubscriptionHistory.DateCreate);

  --ENABLE TRIGGER Gym.tr_GymSubscription ON Gym.t_GymSubscription;
  --ENABLE TRIGGER Gym.tr_GymSubscriptionHistory ON Gym.t_GymSubscriptionHistory;

END;

BEGIN; --26-08-2021, t_Transaction

  PRINT '';

        --DISABLE TRIGGER Transactions.tr_Transaction ON Transactions.t_Transaction;
 
        --UPDATE  Transactions.t_Transaction
        --SET     DetailsCount = ( SELECT COUNT(*)
        --                         FROM   Transactions.t_TransactionDetail AS s
        --                         WHERE  s.TransactionID = t_Transaction.ID
        --                       );

        --ENABLE TRIGGER Transactions.tr_Transaction ON Transactions.t_Transaction;

END;

BEGIN; --02-08-2021, t_Transaction

  PRINT '';

  --DISABLE TRIGGER Transactions.tr_Transaction ON Transactions.t_Transaction;

  --WITH  o AS ( SELECT t.ID ,
  --                t.Ref ,
  --                t.RefF ,
  --                t.TypeIs ,
  --                ( SELECT MAX(s.Ref)
  --                    FROM Transactions.t_Transaction AS s
  --                    WHERE s.TypeIs = N'JV'
  --                ) + ROW_NUMBER() OVER ( PARTITION BY TypeIs ORDER BY TypeIs ) AS Ref_
  --              FROM Transactions.t_Transaction AS t
  --              WHERE t.TypeIs = N'قيد يومي'
  --           )
  --  UPDATE o
  --    SET o.Ref = o.Ref_ ,
  --        o.RefF = FORMAT(o.Ref_, 'n0') ,
  --        o.TypeIs = N'JV';
 
  --WITH  o AS ( SELECT t.ID ,
  --                t.Ref ,
  --                t.RefF ,
  --                t.TypeIs ,
  --                ( SELECT MAX(s.Ref)
  --                    FROM Transactions.t_Transaction AS s
  --                    WHERE s.TypeIs = N'RV'
  --                ) + ROW_NUMBER() OVER ( PARTITION BY TypeIs ORDER BY TypeIs ) AS Ref_
  --              FROM Transactions.t_Transaction AS t
  --              WHERE t.TypeIs = N'سند قبض'
  --           )
  --  UPDATE o
  --    SET o.Ref = o.Ref_ ,
  --        o.RefF = FORMAT(o.Ref_, 'n0') ,
  --        o.TypeIs = N'RV';

  --WITH  o AS ( SELECT t.ID ,
  --                t.Ref ,
  --                t.RefF ,
  --                t.TypeIs ,
  --                ( SELECT MAX(s.Ref)
  --                    FROM Transactions.t_Transaction AS s
  --                    WHERE s.TypeIs = N'PV'
  --                ) + ROW_NUMBER() OVER ( PARTITION BY TypeIs ORDER BY TypeIs ) AS Ref_
  --              FROM Transactions.t_Transaction AS t
  --              WHERE t.TypeIs = N'سند دفع'
  --           )
  --  UPDATE o
  --    SET o.Ref = o.Ref_ ,
  --        o.RefF = FORMAT(o.Ref_, 'n0') ,
  --        o.TypeIs = N'PV';

  --ENABLE TRIGGER Transactions.tr_Transaction ON Transactions.t_Transaction;

END;

BEGIN; --28-07-2021, t_Expense

  PRINT '';

  --DECLARE @CurrencyID UNIQUEIDENTIFIER = Currencys.f_CurrencyGetFirstIDLL();

  --UPDATE Company.t_Expense
  --  SET TaxExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;
 
  --SET @CurrencyID = Currencys.f_CurrencyGetFirstIDEuro();

  --UPDATE Company.t_Expense
  --  SET TaxExchangeRateEuro = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;
   
END;

BEGIN; --09-06-2021, t_PurchasingReturn and t_PurchasingReturnDeleted

  PRINT '';

  --DECLARE @CurrencyID UNIQUEIDENTIFIER = Currencys.f_CurrencyGetFirstIDLL();

  --UPDATE Invoices.t_PurchasingReturn
  --  SET TaxExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;
 
  --UPDATE Invoices.t_PurchasingReturnDeleted
  --  SET TaxExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;
  
END;

BEGIN; --08-06-2021, t_SoldReturn and t_SoldReturnDeleted

  PRINT '';

  --DECLARE @CurrencyID UNIQUEIDENTIFIER = Currencys.f_CurrencyGetFirstIDLL();

  --UPDATE Invoices.t_SoldReturn
  --  SET TaxExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;
 
  --UPDATE Invoices.t_SoldReturnDeleted
  --  SET TaxExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;
  
END;

BEGIN; --07-06-2021, t_Sold, t_Purchasing and t_Currency

  PRINT '';

  --DECLARE @CurrencyID UNIQUEIDENTIFIER = Currencys.f_CurrencyGetFirstIDLL();

  --UPDATE Invoices.t_Sold
  --  SET TaxExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;
 
  --UPDATE Invoices.t_SoldDeleted
  --  SET TaxExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;

  --UPDATE Invoices.t_Purchasing
  --  SET TaxExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;
 
  --UPDATE Invoices.t_PurchasingDeleted
  --  SET TaxExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;

  --UPDATE Currencys.t_Currency
  --  SET ExchangeRateTax = ExchangeRate;

END;

BEGIN; --06-06-2021, t_Sold, t_Purchasing, t_Expense and t_Quotation

  PRINT '';

  --DECLARE @CurrencyID UNIQUEIDENTIFIER = Currencys.f_CurrencyGetFirstIDLL();

  --UPDATE Invoices.t_Sold
  --  SET ExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;

  --UPDATE Invoices.t_Purchasing
  --  SET ExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;
 
  --UPDATE Company.t_Expense
  --  SET ExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;

  --UPDATE Company.t_Expense
  --  SET ExchangeRateLL = ExchangeRate
  --  WHERE CurrencyID = @CurrencyID;

    --UPDATE Quotations.t_Quotation
    --SET ExchangeRateLL = ExchangeRate
    --WHERE CurrencyID = @CurrencyID;
 
    --UPDATE Quotations.t_QuotationHistory
    --SET ExchangeRateLL = ExchangeRate
    --WHERE CurrencyID = @CurrencyID;

END;

BEGIN; --05-06-2021, t_Customer

  PRINT '';

  --UPDATE Customers.t_Customer
  --  SET FrameJobOrderC = Customers.f_FrameJobOrderGetCountByCustomerID(ID) ,
  --      FrameJobOrderTotal = Customers.[f_FrameJobOrderGetTotalByCustomerID](ID) ,
  --      FrameJobOrderProfit = Customers.[f_FrameJobOrderGetProfitByCustomerID](ID) ,
  --      FrameJobOrderLast = Customers.f_FrameJobOrderGetLastDateByCustomerID(ID);

  --WITH  o AS ( SELECT s1.CurrencyID ,
  --                s.FrameJobOrderTotal ,
  --                s.FrameJobOrderTotalF ,
  --                s.FrameJobOrderProfit ,
  --                s.FrameJobOrderProfitF
  --              FROM Customers.t_Customer AS s
  --                INNER JOIN Company.t_Account AS s1 ON s1.LinkWithID = s.ID AND s1.IsMasterLink = 1 AND s1.SectionID = 15
  --           )
  --  UPDATE o
  --    SET o.FrameJobOrderTotalF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderTotal) ,
  --        o.FrameJobOrderProfitF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderProfit);

END;

BEGIN; --04-06-2021, t_Account and t_Customer

  PRINT '';

  --UPDATE Company.t_Account
  --  SET DeliveryServicesC = [Invoices].f_DeliveryServiceGetCountByAccountCustomerID(ID) ,
  --      DeliveryServicesTotal = [Invoices].[f_DeliveryServiceGetTotalByAccountCustomerID](ID) ,
  --      DeliveryServicesProfit = [Invoices].[f_DeliveryServiceGetProfitByAccountCustomerID](ID) ,
  --      DeliveryServicesLastDate = [Invoices].f_DeliveryServiceGetLastDateByAccountCustomerID(ID) ,
  --      PurchasingC = [Invoices].[f_PurchasingGetCountByAccountVendorID](ID) ,
  --      PurchasingTotal = [Invoices].[f_PurchasingGetTotalByAccountVendorID](ID) ,
  --      PurchasingProfit = [Invoices].[f_PurchasingGetProfitByAccountVendorID](ID) ,
  --      PurchasingLast = [Invoices].[f_PurchasingGetLastDateByAccountVendorID](ID) ,
  --      PurchasingReturnC = [Invoices].[f_PurchasingReturnGetCountByAccountVendorID](ID) ,
  --      PurchasingReturnTotal = [Invoices].[f_PurchasingReturnGetTotalByAccountVendorID](ID) ,
  --      PurchasingReturnProfit = [Invoices].[f_PurchasingReturnGetProfitByAccountVendorID](ID) ,
  --      PurchasingReturnLast = [Invoices].[f_PurchasingReturnGetLastDateByAccountVendorID](ID) ,
  --      SoldC = [Invoices].[f_SoldGetCountByAccountCustomerID](ID) ,
  --      SoldTotal = [Invoices].[f_SoldGetTotalByAccountCustomerID](ID) ,
  --      SoldProfit = [Invoices].[f_SoldGetProfitByAccountCustomerID](ID) ,
  --      SoldLast = [Invoices].[f_SoldGetLastDateByAccountCustomerID](ID) ,
  --      SoldReturnC = [Invoices].[f_SoldReturnGetCountByAccountCustomerID](ID) ,
  --      SoldReturnTotal = [Invoices].[f_SoldReturnGetTotalByAccountCustomerID](ID) ,
  --      SoldReturnProfit = [Invoices].[f_SoldReturnGetProfitByAccountCustomerID](ID) ,
  --      SoldReturnLast = [Invoices].[f_SoldReturnGetLastDateByAccountCustomerID](ID) ,
  --      QuotationC = Quotations.[f_QuotationGetCountByAccountID](ID) ,
  --      QuotationTotal = Quotations.[f_QuotationGetTotalByAccountID](ID) ,
  --      QuotationProfit = Quotations.[f_QuotationGetProfitByAccountID](ID) ,
  --      QuotationLast = Quotations.[f_QuotationGetLastDateByAccountID](ID);

  --UPDATE Company.t_Account
  --  SET DeliveryServicesTotalF = Currencys.f_Format(CurrencyID, DeliveryServicesTotal) ,
  --      DeliveryServicesProfitF = Currencys.f_Format(CurrencyID, DeliveryServicesProfit) ,
  --      PurchasingTotalF = Currencys.f_Format(CurrencyID, PurchasingTotal) ,
  --      PurchasingProfitF = Currencys.f_Format(CurrencyID, PurchasingProfit) ,
  --      PurchasingReturnTotalF = Currencys.f_Format(CurrencyID, PurchasingReturnTotal) ,
  --      PurchasingReturnProfitF = Currencys.f_Format(CurrencyID, PurchasingReturnProfit) ,
  --      SoldTotalF = Currencys.f_Format(CurrencyID, SoldTotal) ,
  --      SoldProfitF = Currencys.f_Format(CurrencyID, SoldProfit) ,
  --      SoldReturnTotalF = Currencys.f_Format(CurrencyID, SoldReturnTotal) ,
  --      SoldReturnProfitF = Currencys.f_Format(CurrencyID, SoldReturnProfit) ,
  --      QuotationTotalF = Currencys.f_Format(CurrencyID, QuotationTotal) ,
  --      QuotationProfitF = Currencys.f_Format(CurrencyID, QuotationProfit);

  --UPDATE Customers.t_Customer
  --  SET PrescriptionC = ( SELECT COUNT(t.ID)
  --                          FROM Customers.t_Prescription AS t
  --                          WHERE t.CustomerID = t_Customer.ID
  --                      ) ,
  --      PrescriptionLastDate = COALESCE(( SELECT TOP ( 1 ) t.DateIs
  --                                          FROM Customers.t_Prescription AS t
  --                                          WHERE t.CustomerID = t_Customer.ID
  --                                          ORDER BY t.DateIs DESC
  --                                      ), DATEFROMPARTS(2000, 1, 1)) ,
  --      InternetSubscriptionC = [Invoices].f_InternetSubscriptionGetCountByCustomerID(ID) ,
  --      InternetSubscriptionTotal = [Invoices].[f_InternetSubscriptionGetTotalByCustomerID](ID) ,
  --      InternetSubscriptionProfit = [Invoices].[f_InternetSubscriptionGetProfitByCustomerID](ID) ,
  --      InternetSubscriptionLast = [Invoices].f_InternetSubscriptionGetLastDateByCustomerID(ID);

  --WITH  o AS ( SELECT s1.CurrencyID ,
  --                s.InternetSubscriptionTotal ,
  --                s.InternetSubscriptionTotalF ,
  --                s.InternetSubscriptionProfit ,
  --                s.InternetSubscriptionProfitF
  --              FROM Customers.t_Customer AS s
  --                INNER JOIN Company.t_Account AS s1 ON s1.LinkWithID = s.ID AND s1.IsMasterLink = 1 AND s1.SectionID = 15
  --           )
  --  UPDATE o
  --    SET o.InternetSubscriptionTotalF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionTotal) ,
  --        o.InternetSubscriptionProfitF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionProfit);

END;

BEGIN; --29-05-2021 , t_Account of t_SalesPerson 

  PRINT '';

 --   DECLARE @CurrencyIDLL UNIQUEIDENTIFIER = [Currencys].[f_CurrencyGetFirstIDLL]();
 --   DECLARE @CurrencyIDD UNIQUEIDENTIFIER = [Currencys].[f_CurrencyGetFirstIDD]();
 --   DECLARE @CurrencyIDEuro UNIQUEIDENTIFIER = [Currencys].[f_CurrencyGetFirstIDEuro]();

 --   DECLARE @CurrencyLL NVARCHAR(MAX) = [Currencys].[f_CurrencyGetName](@CurrencyIDLL);
 --   DECLARE @CurrencyD NVARCHAR(MAX) = [Currencys].[f_CurrencyGetName](@CurrencyIDD);
 --   DECLARE @CurrencyEuro NVARCHAR(MAX) = [Currencys].[f_CurrencyGetName](@CurrencyIDEuro);

 --   DECLARE @CurrencyTypeIsLL INT = [Currencys].[f_CurrencyGetTypeIs](@CurrencyIDLL);
 --   DECLARE @CurrencyTypeIsD INT = [Currencys].[f_CurrencyGetTypeIs](@CurrencyIDD);
 --   DECLARE @CurrencyTypeIsEuro INT = [Currencys].[f_CurrencyGetTypeIs](@CurrencyIDEuro);
		
 --   DECLARE @ID UNIQUEIDENTIFIER;
 --   DECLARE @UserID UNIQUEIDENTIFIER = Users.f_UserGetFirstID();
		
	----Sell                                                          
 --   SET @ID = Company.f_AccountLevel1GetIDByNumber(70);
 --   EXEC Company.s_AccountLevel1Update N'مبيعات', N'', @UserID, N'', N'', N'', N'', @ID; 
		
 --   SET @ID = Company.f_AccountLevel2GetIDByNumber(701);
 --   EXEC Company.s_AccountLevel2Update N'مبيعات عامة', N'', @UserID, N'', N'', N'', N'', @ID; 
							
 --   IF EXISTS ( SELECT TOP ( 1 )
 --                       s.ID
 --               FROM    Company.t_AccountLevel3 AS s
 --               WHERE   s.NumberIs = 70108 )
 --   BEGIN
                    
 --       SET @ID = Company.f_AccountLevel3GetIDByNumber(70108);
 --       EXEC Company.s_AccountLevel3Update N'عمولات المندوبين', N'', @UserID, N'', N'', N'', N'', @ID; 

 --   END;
 --   ELSE
 --   BEGIN

 --       INSERT  [Company].[t_AccountLevel3]
 --               ( Level2ID ,
 --                 NumberIs ,
 --                 NumberF ,
 --                 Name
 --               )
 --       VALUES  ( [Company].[f_AccountLevel2GetIDByNumber](701) ,
 --                 70108 ,
 --                 N'70108' ,
 --                 N'عمولات المندوبين'
 --               );

 --   END;

 --   PRINT N'';
	
 --   EXECUTE Employees.s_SalesPersonInsertDefaultData;

 --   UPDATE  Company.t_Account
 --   SET     IsMasterLink = 1
 --   WHERE   NumberIs BETWEEN 4610100000 AND 4610199999;
	
 --   UPDATE  Company.t_Account
 --   SET     IsStatic = 1
 --   WHERE   NumberIs = 4610100001;

 --   DECLARE @Level3ID UNIQUEIDENTIFIER = [Company].[f_AccountLevel3GetIDByNumber](70108);
 --   DECLARE @Level3 NVARCHAR(MAX) = Company.f_AccountLevel3GetName(@Level3ID);

 --   DISABLE TRIGGER Company.tr_Account ON Company.t_Account;

 --   INSERT  INTO Company.t_Account
 --           ( Level3ID ,
 --             Level3 ,
 --             SectionID ,
 --             LinkWithID ,
 --             LinkWith ,
 --             IsMasterLink ,
 --             NumberIs ,
 --             NumberF ,
 --             NumberNet ,
 --             Name ,
 --             CurrencyID ,
 --             Currency ,
 --             CurrencyTypeIs ,
 --             BalanceF ,
 --             LimitF ,
 --             IsStatic
 --           )
 --           SELECT  @Level3ID ,
 --                   @Level3 ,
 --                   149 ,
 --                   s.ID ,
 --                   s.Name ,
 --                   0 ,
 --                   CONVERT(BIGINT, '70108' + s1.NumberNet) ,
 --                   '70108' + s1.NumberNet ,
 --                   s1.NumberNet ,
 --                   s.Name + N' (عمولات البيع)' ,
 --                   s1.CurrencyID ,
 --                   s1.Currency ,
 --                   s1.CurrencyTypeIs ,
 --                   Currencys.f_Format(s1.CurrencyID, 0) ,
 --                   Currencys.f_Format(s1.CurrencyID, 0) ,
 --                   s1.IsStatic
 --           FROM    Employees.t_SalesPerson AS s
 --                   LEFT JOIN Company.t_Account AS s1 ON s1.LinkWithID = s.ID
 --                                                        AND s1.SectionID = 149
 --                                                        AND s1.IsMasterLink = 1;

 --   ENABLE TRIGGER Company.tr_Account ON Company.t_Account;
	
END;

BEGIN; --28-05-2021 t_ItemShared

  PRINT '';

    --UPDATE  Items.t_ItemShared
    --SET     Purchase = ( SELECT COALESCE(SUM(CASE Currencys.f_CurrencyGetTypeIs(s1.CurrencyID)
    --                                           WHEN 0 THEN s1.PurchaseD * s.Qtys
    --                                           WHEN 1 THEN s1.PurchaseLL * s.Qtys
    --                                           ELSE s1.PurchaseEuro * s.Qtys
    --                                         END), 0)
    --                     FROM   Items.t_ItemSharedMaterial AS s
    --                            LEFT JOIN Items.t_ItemShared AS s1 ON s1.ID = s.ItemSharedID
    --                     WHERE  s.ItemSharedFatherID = t_ItemShared.ID
    --                   )
    --WHERE   EXISTS ( SELECT TOP ( 1 )
    --                        s.ID
    --                 FROM   Items.t_ItemSharedMaterial AS s
    --                 WHERE  s.ItemSharedFatherID = t_ItemShared.ID );

    --WITH    o AS ( SELECT   s.ID ,
    --                        s.CurrencyID ,
    --                        s.Purchase ,
    --                        s.PurchaseD ,
    --                        s.PurchaseLL ,
    --                        s.PurchaseEuro ,
    --                        s.PurchaseWithTax ,
    --                        Calculation.Rate(s.Purchase, s.TaxRate) AS PurchaseWithTax_ ,
    --                        s.PurchaseWithTaxD ,
    --                        s.PurchaseWithTaxLL ,
    --                        s.PurchaseWithTaxEuro ,
    --                        s1.ExchangeRate
    --               FROM     Items.t_ItemShared AS s
    --                        LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
    --               WHERE    EXISTS ( SELECT TOP ( 1 )
    --                                        ss.ID
    --                                 FROM   Items.t_ItemSharedMaterial AS ss
    --                                 WHERE  ss.ItemSharedFatherID = s.ID )
    --             )
    --    UPDATE  o
    --    SET     o.PurchaseD = o.Purchase / o.ExchangeRate ,
    --            o.PurchaseLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.Purchase, o.Purchase / o.ExchangeRate) ,
    --            o.PurchaseEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.Purchase, o.Purchase / o.ExchangeRate) ,
    --            o.PurchaseWithTax = o.PurchaseWithTax_ ,
    --            o.PurchaseWithTaxD = o.PurchaseWithTax_ / o.ExchangeRate ,
    --            o.PurchaseWithTaxLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.PurchaseWithTax_, o.PurchaseWithTax_ / o.ExchangeRate) ,
    --            o.PurchaseWithTaxEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.PurchaseWithTax_, o.PurchaseWithTax_ / o.ExchangeRate)
    --    WHERE   EXISTS ( SELECT TOP ( 1 )
    --                            s.ID
    --                     FROM   Items.t_ItemSharedMaterial AS s
    --                     WHERE  s.ItemSharedFatherID = o.ID );

    --UPDATE  Items.t_ItemShared
    --SET     PurchaseF = Currencys.f_Format(CurrencyID, Purchase) ,
    --        PurchaseWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax) ,
    --        PurchaseTotal = Purchase * QtyCurrent ,
    --        PurchaseTotalF = Currencys.f_Format(CurrencyID, Purchase * QtyCurrent) ,
    --        PurchaseTotalD = PurchaseD * QtyCurrent ,
    --        PurchaseTotalLL = PurchaseLL * QtyCurrent ,
    --        PurchaseTotalEuro = PurchaseEuro * QtyCurrent ,
    --        PurchaseTotalWithTax = PurchaseWithTax * QtyCurrent ,
    --        PurchaseTotalWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax * QtyCurrent) ,
    --        PurchaseTotalWithTaxD = PurchaseWithTaxD * QtyCurrent ,
    --        PurchaseTotalWithTaxLL = PurchaseWithTaxLL * QtyCurrent ,
    --        PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent
    --WHERE   EXISTS ( SELECT TOP ( 1 )
    --                        s.ID
    --                 FROM   Items.t_ItemSharedMaterial AS s
    --                 WHERE  s.ItemSharedFatherID = t_ItemShared.ID );

END;

BEGIN; --25-05-2021 t_Sold

  PRINT '';

    --UPDATE  Invoices.t_Sold
    --SET     Cost = ( SELECT COALESCE(SUM(s.Cost * s.Qty), 0)
    --                 FROM   Invoices.t_SoldDetail AS s
    --                 WHERE  s.SoldID = t_Sold.ID
    --               );

END;

BEGIN; --10-05-2021 t_ItemShared

  PRINT '';

    --UPDATE  Items.t_ItemShared
    --SET     ColorIs = AdditionalProperty1;

END;

BEGIN; --30-04-2021 s_DoctorInsertDefaultData

  PRINT '';

        --EXECUTE Company.s_DoctorInsertDefaultData;

END; 
	     
BEGIN; --30-04-2021 s_BankInsertDefaultData, t_Account 51

  PRINT '';

        --EXECUTE Company.s_BankInsertDefaultData;

        --IF NOT EXISTS ( SELECT TOP ( 1 )
        --                    s.ID
        --            FROM    Company.t_Account AS s
        --            WHERE   s.NumberIs = 5120100001 )
        --    BEGIN

        --        DECLARE @CurrencyIDLL UNIQUEIDENTIFIER = [Currencys].[f_CurrencyGetFirstIDLL]();

        --        DECLARE @CurrencyLL NVARCHAR(MAX) = [Currencys].[f_CurrencyGetName](@CurrencyIDLL);

        --        DECLARE @CurrencyTypeIsLL INT = [Currencys].[f_CurrencyGetTypeIs](@CurrencyIDLL);

        --        INSERT  [Company].[t_Account]
        --                ( Level3ID ,
        --                  NumberIs ,
        --                  NumberF ,
        --                  Name ,
        --                  LinkWithID ,
        --                  LinkWith ,
        --                  SectionID ,
        --                  IsMasterLink ,
        --                  IsStatic ,
        --                  CurrencyID ,
        --                  Currency ,
        --                  CurrencyTypeIs
        --                )
        --        VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](51201) ,
        --                  5120100001 ,
        --                  N'5120100001' ,
        --                  N'البنك الإفتراضي' ,
        --                  Company.f_BankGetFirstID() ,
        --                  Company.f_BankGetFirstName() ,
        --                  38 ,
        --                  1 ,
        --                  1 ,
        --                  @CurrencyIDLL ,
        --                  @CurrencyLL ,
        --                  @CurrencyTypeIsLL
        --                );

        --    END;

END;

BEGIN; --10-04-2021 t_DeliveryService

  PRINT '';

        --DECLARE @T AS TABLE ( ID UNIQUEIDENTIFIER );

        --WITH    o AS ( SELECT   t.ID ,
        --                        ROW_NUMBER() OVER ( PARTITION BY t.AccountVendorID, t.RefPaper ORDER BY t.AccountVendorID , t.RefPaper ) AS NumberIs
        --               FROM     ( SELECT    s.ID ,
        --                                    s.RefPaper ,
        --                                    s.AccountVendorID
        --                          FROM      Invoices.t_DeliveryService AS s
        --                          UNION ALL
        --                          SELECT    s.ID ,
        --                                    s.RefPaper ,
        --                                    s.AccountVendorID
        --                          FROM      Invoices.t_DeliveryServiceHistory AS s
        --                        ) AS t
        --             )
        --    INSERT  @T
        --            ( ID
        --            )
        --            SELECT  o.ID
        --            FROM    o
        --            WHERE   o.NumberIs > 1;

        --UPDATE  Invoices.t_DeliveryService
        --SET     RefPaper = RefF + N' \ (' + RefPaper + N') Duplicated'
        --WHERE   EXISTS ( SELECT TOP ( 1 )
        --                        s.ID
        --                 FROM   @T AS s
        --                 WHERE  s.ID = t_DeliveryService.ID );

        --UPDATE  Invoices.t_DeliveryServiceHistory
        --SET     RefPaper = RefF + N' \ (' + RefPaper + N') Duplicated'
        --WHERE   EXISTS ( SELECT TOP ( 1 )
        --                        s.ID
        --                 FROM   @T AS s
        --                 WHERE  s.ID = t_DeliveryServiceHistory.ID );

END;

BEGIN; --21-03-2021 t_Account 60, 70

  PRINT '';

  --      DECLARE @CurrencyIDLL UNIQUEIDENTIFIER = [Currencys].[f_CurrencyGetFirstIDLL]();
  --      DECLARE @CurrencyIDD UNIQUEIDENTIFIER = [Currencys].[f_CurrencyGetFirstIDD]();
  --      DECLARE @CurrencyIDEuro UNIQUEIDENTIFIER = [Currencys].[f_CurrencyGetFirstIDEuro]();

  --      DECLARE @CurrencyLL NVARCHAR(MAX) = [Currencys].[f_CurrencyGetName](@CurrencyIDLL);
  --      DECLARE @CurrencyD NVARCHAR(MAX) = [Currencys].[f_CurrencyGetName](@CurrencyIDD);
  --      DECLARE @CurrencyEuro NVARCHAR(MAX) = [Currencys].[f_CurrencyGetName](@CurrencyIDEuro);

  --      DECLARE @CurrencyTypeIsLL INT = [Currencys].[f_CurrencyGetTypeIs](@CurrencyIDLL);
  --      DECLARE @CurrencyTypeIsD INT = [Currencys].[f_CurrencyGetTypeIs](@CurrencyIDD);
  --      DECLARE @CurrencyTypeIsEuro INT = [Currencys].[f_CurrencyGetTypeIs](@CurrencyIDEuro);
		
  --      DECLARE @ID UNIQUEIDENTIFIER;
  --      DECLARE @UserID UNIQUEIDENTIFIER = Users.f_UserGetFirstID();
		
		----Sell                                                          
  --      SET @ID = Company.f_AccountLevel1GetIDByNumber(70);
  --      EXEC Company.s_AccountLevel1Update N'مبيعات', N'', @UserID, N'', N'',
  --          N'', N'', @ID; 
		
  --      SET @ID = Company.f_AccountLevel2GetIDByNumber(701);
  --      EXEC Company.s_AccountLevel2Update N'مبيعات عامة', N'', @UserID, N'',
  --          N'', N'', N'', @ID; 
							
  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_AccountLevel3 AS s
  --                  WHERE   s.NumberIs = 70101 )
  --          BEGIN
                    
  --              SET @ID = Company.f_AccountLevel3GetIDByNumber(70101);
  --              EXEC Company.s_AccountLevel3Update N'مبيعات غير خاضعة', N'',
  --                  @UserID, N'', N'', N'', N'', @ID; 

  --          END;
  --      ELSE
  --          BEGIN

  --              INSERT  [Company].[t_AccountLevel3]
  --                      ( Level2ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel2GetIDByNumber](701) ,
  --                        70101 ,
  --                        N'70101' ,
  --                        N'مبيعات غير خاضعة'
  --                      );

  --          END;
			
  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 7010100001 )
  --          BEGIN

  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 7010100001;
				
  --              EXEC Company.s_AccountUpdate N'مبيعات لبناني غير خاضعة',
  --                  @CurrencyIDLL, 0, N'', @UserID, N'', 1, N'', N'', N'', @ID; 
			
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](70101) ,
  --                        7010100001 ,
  --                        N'7010100001' ,
  --                        N'مبيعات لبناني غير خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDLL ,
  --                        @CurrencyLL ,
  --                        @CurrencyTypeIsLL
  --                      );

  --          END;

  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 7010100002 )
  --          BEGIN
			 
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 7010100002;
				
  --              EXEC Company.s_AccountUpdate N'مبيعات دولار غير خاضعة',
  --                  @CurrencyIDD, 0, N'', @UserID, N'', 1, N'', N'', N'', @ID; 
						
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](70101) ,
  --                        7010100002 ,
  --                        N'7010100002' ,
  --                        N'مبيعات دولار غير خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDD ,
  --                        @CurrencyD ,
  --                        @CurrencyTypeIsD
  --                      );

  --          END;

  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 7010100003 )
  --          BEGIN
			 
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 7010100003;
				
  --              EXEC Company.s_AccountUpdate N'مبيعات يورو غير خاضعة',
  --                  @CurrencyIDEuro, 0, N'', @UserID, N'', 1, N'', N'', N'',
  --                  @ID; 
						
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](70101) ,
  --                        7010100003 ,
  --                        N'7010100003' ,
  --                        N'مبيعات يورو غير خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDEuro ,
  --                        @CurrencyEuro ,
  --                        @CurrencyTypeIsEuro
  --                      );

  --          END;
		
  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_AccountLevel3 AS s
  --                  WHERE   s.NumberIs = 70102 )
  --          BEGIN
                                                          
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_AccountLevel3 AS s
  --              WHERE   s.NumberIs = 70102;
				
  --              EXEC Company.s_AccountLevel3Update N'مبيعات خاضعة', N'',
  --                  @UserID, N'', N'', N'', N'', @ID; 

  --          END;
  --      ELSE
  --          BEGIN

  --              INSERT  [Company].[t_AccountLevel3]
  --                      ( Level2ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel2GetIDByNumber](701) ,
  --                        70102 ,
  --                        N'70102' ,
  --                        N'مبيعات خاضعة'
  --                      );

  --          END;
				
  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 7010200001 )
  --          BEGIN
			            
  --              SET @UserID = Users.f_UserGetFirstID();
						
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 7010200001;
				
  --              EXEC Company.s_AccountUpdate N'مبيعات لبناني خاضعة',
  --                  @CurrencyIDLL, 0, N'', @UserID, N'', 1, N'', N'', N'', @ID; 
			
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](70102) ,
  --                        7010200001 ,
  --                        N'7010200001' ,
  --                        N'مبيعات لبناني خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDLL ,
  --                        @CurrencyLL ,
  --                        @CurrencyTypeIsLL
  --                      );

  --          END;

  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 7010200002 )
  --          BEGIN
			 
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 7010200002;
				
  --              EXEC Company.s_AccountUpdate N'مبيعات دولار خاضعة',
  --                  @CurrencyIDD, 0, N'', @UserID, N'', 1, N'', N'', N'', @ID; 
						
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](70102) ,
  --                        7010200002 ,
  --                        N'7010200002' ,
  --                        N'مبيعات دولار خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDD ,
  --                        @CurrencyD ,
  --                        @CurrencyTypeIsD
  --                      );

  --          END;

  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 7010200003 )
  --          BEGIN
			 
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 7010200003;
				
  --              EXEC Company.s_AccountUpdate N'مبيعات يورو خاضعة',
  --                  @CurrencyIDEuro, 0, N'', @UserID, N'', 1, N'', N'', N'',
  --                  @ID; 
						
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](70102) ,
  --                        7010200003 ,
  --                        N'7010200003' ,
  --                        N'مبيعات يورو خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDEuro ,
  --                        @CurrencyEuro ,
  --                        @CurrencyTypeIsEuro
  --                      );

  --          END;

  --      UPDATE  Company.t_Account
  --      SET     IsStatic = 1
  --      WHERE   NumberIs BETWEEN 7010100000 AND 7010100003;

  --      UPDATE  Company.t_Account
  --      SET     IsStatic = 1
  --      WHERE   NumberIs BETWEEN 7010200000 AND 7010200003;

		----Purchase
  --      SET @ID = Company.f_AccountLevel1GetIDByNumber(60);
  --      EXEC Company.s_AccountLevel1Update N'مشتريات', N'', @UserID, N'', N'',
  --          N'', N'', @ID; 
		
  --      SET @ID = Company.f_AccountLevel2GetIDByNumber(601);
  --      EXEC Company.s_AccountLevel2Update N'مشتريات عامة', N'', @UserID, N'',
  --          N'', N'', N'', @ID; 
							
  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_AccountLevel3 AS s
  --                  WHERE   s.NumberIs = 60101 )
  --          BEGIN
                    
  --              SET @ID = Company.f_AccountLevel3GetIDByNumber(60101);
  --              EXEC Company.s_AccountLevel3Update N'مشتريات غير خاضعة', N'',
  --                  @UserID, N'', N'', N'', N'', @ID; 

  --          END;
  --      ELSE
  --          BEGIN

  --              INSERT  [Company].[t_AccountLevel3]
  --                      ( Level2ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel2GetIDByNumber](601) ,
  --                        60101 ,
  --                        N'60101' ,
  --                        N'مشتريات غير خاضعة'
  --                      );

  --          END;
			
  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 6010100001 )
  --          BEGIN

  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 6010100001;
				
  --              EXEC Company.s_AccountUpdate N'مشتريات لبناني غير خاضعة',
  --                  @CurrencyIDLL, 0, N'', @UserID, N'', 1, N'', N'', N'', @ID; 
			
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](60101) ,
  --                        6010100001 ,
  --                        N'6010100001' ,
  --                        N'مشتريات لبناني غير خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDLL ,
  --                        @CurrencyLL ,
  --                        @CurrencyTypeIsLL
  --                      );

  --          END;

  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 6010100002 )
  --          BEGIN
			 
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 6010100002;
				
  --              EXEC Company.s_AccountUpdate N'مشتريات دولار غير خاضعة',
  --                  @CurrencyIDD, 0, N'', @UserID, N'', 1, N'', N'', N'', @ID; 
						
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](60101) ,
  --                        6010100002 ,
  --                        N'6010100002' ,
  --                        N'مشتريات دولار غير خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDD ,
  --                        @CurrencyD ,
  --                        @CurrencyTypeIsD
  --                      );

  --          END;

  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 6010100003 )
  --          BEGIN
			 
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 6010100003;
				
  --              EXEC Company.s_AccountUpdate N'مشتريات يورو غير خاضعة',
  --                  @CurrencyIDEuro, 0, N'', @UserID, N'', 1, N'', N'', N'',
  --                  @ID; 
						
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](60101) ,
  --                        6010100003 ,
  --                        N'6010100003' ,
  --                        N'مشتريات يورو غير خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDEuro ,
  --                        @CurrencyEuro ,
  --                        @CurrencyTypeIsEuro
  --                      );

  --          END;
		
  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_AccountLevel3 AS s
  --                  WHERE   s.NumberIs = 60102 )
  --          BEGIN
                                                          
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_AccountLevel3 AS s
  --              WHERE   s.NumberIs = 60102;
				
  --              EXEC Company.s_AccountLevel3Update N'مشتريات خاضعة', N'',
  --                  @UserID, N'', N'', N'', N'', @ID; 

  --          END;
  --      ELSE
  --          BEGIN

  --              INSERT  [Company].[t_AccountLevel3]
  --                      ( Level2ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel2GetIDByNumber](601) ,
  --                        60102 ,
  --                        N'60102' ,
  --                        N'مشتريات خاضعة'
  --                      );

  --          END;
				
  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 6010200001 )
  --          BEGIN
			            
  --              SET @UserID = Users.f_UserGetFirstID();
						
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 6010200001;
				
  --              EXEC Company.s_AccountUpdate N'مشتريات لبناني خاضعة',
  --                  @CurrencyIDLL, 0, N'', @UserID, N'', 1, N'', N'', N'', @ID; 
			
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](60102) ,
  --                        6010200001 ,
  --                        N'6010200001' ,
  --                        N'مشتريات لبناني خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDLL ,
  --                        @CurrencyLL ,
  --                        @CurrencyTypeIsLL
  --                      );

  --          END;

  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 6010200002 )
  --          BEGIN
			 
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 6010200002;
				
  --              EXEC Company.s_AccountUpdate N'مشتريات دولار خاضعة',
  --                  @CurrencyIDD, 0, N'', @UserID, N'', 1, N'', N'', N'', @ID; 
						
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](60102) ,
  --                        6010200002 ,
  --                        N'6010200002' ,
  --                        N'مشتريات دولار خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDD ,
  --                        @CurrencyD ,
  --                        @CurrencyTypeIsD
  --                      );

  --          END;

  --      IF EXISTS ( SELECT TOP ( 1 )
  --                          s.ID
  --                  FROM    Company.t_Account AS s
  --                  WHERE   s.NumberIs = 6010200003 )
  --          BEGIN
			 
  --              SELECT TOP ( 1 )
  --                      @ID = s.ID
  --              FROM    Company.t_Account AS s
  --              WHERE   s.NumberIs = 6010200003;
				
  --              EXEC Company.s_AccountUpdate N'مشتريات يورو خاضعة',
  --                  @CurrencyIDEuro, 0, N'', @UserID, N'', 1, N'', N'', N'',
  --                  @ID; 
						
  --          END;
  --      ELSE
  --          BEGIN
			         
  --              INSERT  [Company].[t_Account]
  --                      ( Level3ID ,
  --                        NumberIs ,
  --                        NumberF ,
  --                        Name ,
  --                        LinkWithID ,
  --                        LinkWith ,
  --                        SectionID ,
  --                        IsMasterLink ,
  --                        IsStatic ,
  --                        CurrencyID ,
  --                        Currency ,
  --                        CurrencyTypeIs
  --                      )
  --              VALUES  ( [Company].[f_AccountLevel3GetIDByNumber](60102) ,
  --                        6010200003 ,
  --                        N'6010200003' ,
  --                        N'مشتريات يورو خاضعة' ,
  --                        '00000000-0000-0000-0000-000000000000' ,
  --                        N'' ,
  --                        69 ,
  --                        0 ,
  --                        1 ,
  --                        @CurrencyIDEuro ,
  --                        @CurrencyEuro ,
  --                        @CurrencyTypeIsEuro
  --                      );

  --          END;

  --      UPDATE  Company.t_Account
  --      SET     IsStatic = 1
  --      WHERE   NumberIs BETWEEN 6010100000 AND 6010100003;

  --      UPDATE  Company.t_Account
  --      SET     IsStatic = 1
  --      WHERE   NumberIs BETWEEN 6010200000 AND 6010200003;

END;

BEGIN; --16-03-2021 t_InternetSubscription

  PRINT '';

        --UPDATE  Invoices.t_InternetSubscription
        --SET     Profit = Price ,
        --        ProfitF = PriceF ,
        --        ProfitD = PriceD ,
        --        ProfitLL = PriceLL ,
        --        ProfitEuro = PriceEuro ,
        --        ProfitCollected = Paid ,
        --        ProfitCollectedF = PaidF ,
        --        ProfitCollectedD = PaidD ,
        --        ProfitCollectedLL = PaidLL ,
        --        ProfitCollectedEuro = PaidEuro;

        --UPDATE  Invoices.t_InternetSubscriptionHistory
        --SET     Profit = Price ,
        --        ProfitF = PriceF ,
        --        ProfitD = PriceD ,
        --        ProfitLL = PriceLL ,
        --        ProfitEuro = PriceEuro ,
        --        ProfitCollected = Paid ,
        --        ProfitCollectedF = PaidF ,
        --        ProfitCollectedD = PaidD ,
        --        ProfitCollectedLL = PaidLL ,
        --        ProfitCollectedEuro = PaidEuro;

END;

BEGIN; --02-02-2021 t_TransferDetail

  PRINT '';

    --WITH o
    --AS (SELECT s.Qtys,
    --           s.Qty * s1.Qty AS Qtys_
    --    FROM Invoices.t_TransferDetail AS s
    --        LEFT JOIN Items.t_UnityItem AS s1
    --            ON s1.ID = s.ItemUnityID
    --    WHERE s.Qtys <> s.Qty * s1.Qty)
    --UPDATE o
    --SET Qtys = Qtys_;

END;

BEGIN; --05-01-2021 t_Sold

  PRINT '';

--UPDATE Invoices.t_Sold
--SET TimeOnly = DateIs;

END;

BEGIN; --04-01-2021 s_WorldFoodProgrammeInsertDefaultData

  PRINT '';

--EXECUTE Options.s_WorldFoodProgrammeInsertDefaultData;

END;

BEGIN; --12-12-2020 t_Account

  PRINT '';

--UPDATE Company.t_Account
--SET IsMasterLink = 1
--WHERE NumberIs
--BETWEEN 4210100000 AND 4210199999;

END;

BEGIN; --28-11-2020 s_InvoiceTitleInsertDefaultData

  PRINT '';

--EXECUTE Invoices.s_InvoiceTitleInsertDefaultData;

END;

BEGIN; --12-11-2020 t_Expense

  PRINT '';

--UPDATE Company.t_Expense
--SET TaxValueF = Currencys.f_Format(CurrencyID, 0),
--    NetIs = Balance,
--    NetIsF = BalanceF,
--    NetIsD = BalanceD,
--    NetIsLL = BalanceLL,
--    NetIsEuro = BalanceEuro,
--    NetIsAR = Currencys.f_ToWordAR(Balance, CurrencyID, 1),
--    NetIsEN = Currencys.f_ToWordEN(Balance, CurrencyID, 1);

END;

BEGIN; --11-11-2020 t_ItemSharedBarCode

  PRINT '';

--UPDATE Items.t_ItemSharedBarCode
--SET BarcodeNumber = Alls.f_ToBigint(Barcode);

END;

BEGIN; --10-11-2020 t_Account 40, 41, 44 

  PRINT '';

--UPDATE Company.t_Account
--SET IsStatic = 0
--WHERE NumberIs
--BETWEEN 4010100000 AND 4010199999;

--WITH o
--AS (SELECT TOP (1)
--           s.IsStatic
--    FROM Company.t_Account AS s
--    WHERE s.NumberIs
--    BETWEEN 4010100000 AND 4010199999
--    ORDER BY s.NumberIs)
--UPDATE o
--SET o.IsStatic = 1;

--UPDATE Company.t_Account
--SET IsStatic = 0
--WHERE NumberIs
--BETWEEN 4110100000 AND 4110199999;

--WITH o
--AS (SELECT TOP (1)
--           s.IsStatic
--    FROM Company.t_Account AS s
--    WHERE s.NumberIs
--    BETWEEN 4110100000 AND 4110199999
--    ORDER BY s.NumberIs)
--UPDATE o
--SET o.IsStatic = 1;

--UPDATE Company.t_Account
--SET IsStatic = 0
--WHERE NumberIs
--BETWEEN 4421000000 AND 4421099999;

--WITH o
--AS (SELECT TOP (1)
--           s.IsStatic
--    FROM Company.t_Account AS s
--    WHERE s.NumberIs
--    BETWEEN 4421000000 AND 4421099999
--    ORDER BY s.NumberIs)
--UPDATE o
--SET o.IsStatic = 1;

--UPDATE Company.t_Account
--SET IsStatic = 0
--WHERE NumberIs
--BETWEEN 4427000000 AND 4427099999;

--WITH o
--AS (SELECT TOP (1)
--           s.IsStatic
--    FROM Company.t_Account AS s
--    WHERE s.NumberIs
--    BETWEEN 4427000000 AND 4427099999
--    ORDER BY s.NumberIs)
--UPDATE o
--SET o.IsStatic = 1;

END;

BEGIN; --07-11-2020 t_Account of t_Customer, t_Vendor

  PRINT '';

    --UPDATE Company.t_Account
    --SET IsMasterLink = 1
    --WHERE SectionID = 15;

    --DECLARE @Level3ID UNIQUEIDENTIFIER = [Company].[f_AccountLevel3GetIDByNumber](44270);
    --DECLARE @Level3 NVARCHAR(MAX) = Company.f_AccountLevel3GetName(@Level3ID);

    --DISABLE TRIGGER Company.tr_Account ON Company.t_Account;

    --UPDATE Company.t_Account
    --SET IsStatic = 1
    --WHERE NumberIs = 4110100001;

    --INSERT INTO Company.t_Account
    --(
    --    Level3ID,
    --    Level3,
    --    SectionID,
    --    LinkWithID,
    --    LinkWith,
    --    IsMasterLink,
    --    NumberIs,
    --    NumberF,
    --    NumberNet,
    --    Name,
    --    CurrencyID,
    --    Currency,
    --    CurrencyTypeIs,
    --    BalanceF,
    --    LimitF,
    --    IsStatic
    --)
    --SELECT @Level3ID,
    --       @Level3,
    --       15,
    --       s.ID,
    --       s.Name,
    --       0,
    --       CONVERT(BIGINT, '44270' + s1.NumberNet),
    --       '44270' + s1.NumberNet,
    --       s1.NumberNet,
    --       s.Name + N' (الضريبة)',
    --       s1.CurrencyID,
    --       s1.Currency,
    --       s1.CurrencyTypeIs,
    --       Currencys.f_Format(s1.CurrencyID, 0),
    --       Currencys.f_Format(s1.CurrencyID, 0),
    --       s1.IsStatic
    --FROM Customers.t_Customer AS s
    --    LEFT JOIN Company.t_Account AS s1
    --        ON s1.LinkWithID = s.ID
    --           AND s1.SectionID = 15
    --           AND s1.IsMasterLink = 1;

    --ENABLE TRIGGER Company.tr_Account ON Company.t_Account;

  PRINT '';

--UPDATE Company.t_Account
--SET IsMasterLink = 1
--WHERE SectionID = 67;

--DECLARE @Level3ID UNIQUEIDENTIFIER = [Company].[f_AccountLevel3GetIDByNumber](44210);
--DECLARE @Level3 NVARCHAR(MAX) = Company.f_AccountLevel3GetName(@Level3ID);

--DISABLE TRIGGER Company.tr_Account ON Company.t_Account;

--UPDATE Company.t_Account
--SET IsStatic = 1
--WHERE NumberIs = 4010100001;

--INSERT INTO Company.t_Account
--(
--    Level3ID,
--    Level3,
--    SectionID,
--    LinkWithID,
--    LinkWith,
--    IsMasterLink,
--    NumberIs,
--    NumberF,
--    NumberNet,
--    Name,
--    CurrencyID,
--    Currency,
--    CurrencyTypeIs,
--    BalanceF,
--    LimitF,
--    IsStatic
--)
--SELECT @Level3ID,
--       @Level3,
--       67,
--       s.ID,
--       s.Name,
--       0,
--       CONVERT(BIGINT, '44210' + s1.NumberNet),
--       '44210' + s1.NumberNet,
--       s1.NumberNet,
--       s.Name + N' (الضريبة)',
--       s1.CurrencyID,
--       s1.Currency,
--       s1.CurrencyTypeIs,
--       Currencys.f_Format(s1.CurrencyID, 0),
--       Currencys.f_Format(s1.CurrencyID, 0),
--       s1.IsStatic
--FROM Vendors.t_Vendor AS s
--    LEFT JOIN Company.t_Account AS s1
--        ON s1.LinkWithID = s.ID
--           AND s1.SectionID = 67
--           AND s1.IsMasterLink = 1;

--ENABLE TRIGGER Company.tr_Account ON Company.t_Account;

END;

BEGIN; --01-11-2020

  PRINT '';

--WITH o
--AS (SELECT t.TypeIs,
--           t1.TypeIs AS TypeIs_
--    FROM Items.t_Item AS t
--        LEFT JOIN Items.t_ItemShared AS t1
--            ON t1.ID = t.SharedID)
--UPDATE o
--SET o.TypeIs = o.TypeIs_;

--UPDATE Items.t_ItemShared
--SET ReplenishmentSystem = 4
--WHERE TypeIs = 1;

END;

BEGIN; --29-08-2020

  PRINT '';

--WITH o
--AS (SELECT s.Price,
--           s.PriceWithTax,
--           s1.TaxRate
--    FROM Items.t_UnityItem AS s
--        LEFT JOIN Items.t_ItemShared AS s1
--            ON s1.ID = s.SharedID)
--UPDATE o
--SET o.PriceWithTax = Calculation.Rate(o.Price, o.TaxRate);

--DECLARE @t AS TABLE
--(
--    ItemSharedID UNIQUEIDENTIFIER NOT NULL,
--    CurrencyID UNIQUEIDENTIFIER NOT NULL,
--    Currency NVARCHAR(MAX) NOT NULL,
--    ExchangeRate DECIMAL(18, 2) NOT NULL,
--    Price FLOAT NOT NULL,
--    PriceWithTax FLOAT NOT NULL
--);

--INSERT INTO @t
--(
--    ItemSharedID,
--    CurrencyID,
--    Currency,
--    ExchangeRate,
--    Price,
--    PriceWithTax
--)
--SELECT s.SharedID,
--       s.CurrencyID,
--       s1.Name,
--       s1.ExchangeRate,
--       s.Price,
--       Calculation.Rate(s.Price, s2.TaxRate)
--FROM Items.t_UnityItem AS s
--    LEFT JOIN Currencys.t_Currency AS s1
--        ON s1.ID = s.CurrencyID
--    LEFT JOIN Items.t_ItemShared AS s2
--        ON s2.ID = s.SharedID
--WHERE s.PrimaryIs = 1 AND s.Qty = 1;

--MERGE Items.t_ItemShared AS t
--USING @t AS s
--ON s.ItemSharedID = t.ID
--WHEN MATCHED THEN
--    UPDATE SET t.SellCurrencyID = s.CurrencyID,
--               t.SellCurrency = s.Currency,
--               t.Sell = s.Price,
--               t.SellF = Currencys.f_Format(s.CurrencyID, s.Price),
--               t.SellD = s.Price / s.ExchangeRate,
--               t.SellLL = Currencys.f_ExchangeToLL(s.CurrencyID, s.Price, s.Price / s.ExchangeRate),
--               t.SellEuro = Currencys.f_ExchangeToEuro(s.CurrencyID, s.Price, s.Price / s.ExchangeRate),
--               t.SellWithTax = s.PriceWithTax,
--               t.SellWithTaxF = Currencys.f_Format(s.CurrencyID, s.PriceWithTax),
--               t.SellWithTaxD = s.PriceWithTax / s.ExchangeRate,
--               t.SellWithTaxLL = Currencys.f_ExchangeToLL(
--                                                             s.CurrencyID,
--                                                             s.PriceWithTax,
--                                                             s.PriceWithTax / s.ExchangeRate
--                                                         ),
--               t.SellWithTaxEuro = Currencys.f_ExchangeToEuro(
--                                                                 s.CurrencyID,
--                                                                 s.PriceWithTax,
--                                                                 s.PriceWithTax / s.ExchangeRate
--                                                             );

--UPDATE Items.t_ItemShared
--SET SellTotal = Sell * QtyCurrent,
--    SellTotalF = Currencys.f_Format(SellCurrencyID, Sell * QtyCurrent),
--    SellTotalD = SellD * QtyCurrent,
--    SellTotalLL = SellLL * QtyCurrent,
--    SellTotalEuro = SellEuro * QtyCurrent,
--    SellTotalWithTax = SellWithTax * QtyCurrent,
--    SellTotalWithTaxF = Currencys.f_Format(SellCurrencyID, SellWithTax * QtyCurrent),
--    SellTotalWithTaxD = SellWithTaxD * QtyCurrent,
--    SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent,
--    SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent;

END;

BEGIN; --04-08-2020

  PRINT '';

--WITH o
--AS (SELECT COALESCE(t2.DateIs, t.DateCreate) AS DateIs,
--           t.LastStockTakeDate
--    FROM Items.t_Item AS t
--        FULL JOIN Items.t_StockTakeDetail AS t1
--            ON t1.ItemID = t.ID
--        LEFT JOIN Items.t_StockTake AS t2
--            ON t2.ID = t1.StockTakeID)
--UPDATE o
--SET o.LastStockTakeDate = o.DateIs;

END;

BEGIN; --29-07-2020

  PRINT '';

--DECLARE @t AS TABLE
--(
--    ItemSharedID UNIQUEIDENTIFIER NOT NULL,
--    CurrencyID UNIQUEIDENTIFIER NOT NULL,
--    Currency NVARCHAR(MAX) NOT NULL,
--    ExchangeRate DECIMAL(18, 2) NOT NULL,
--    Price FLOAT NOT NULL,
--    PriceWithTax FLOAT NOT NULL
--);

--INSERT INTO @t
--(
--    ItemSharedID,
--    CurrencyID,
--    Currency,
--    ExchangeRate,
--    Price,
--    PriceWithTax
--)
--SELECT s.SharedID,
--       s.CurrencyID,
--       s1.Name,
--       s1.ExchangeRate,
--       s.Price,
--       Calculation.Rate(s.Price, s2.TaxRate)
--FROM Items.t_UnityItem AS s
--    LEFT JOIN Currencys.t_Currency AS s1
--        ON s1.ID = s.CurrencyID
--    LEFT JOIN Items.t_ItemShared AS s2
--        ON s2.ID = s.SharedID
--WHERE s.PrimaryIs = 1 AND s.Qty = 1;

--MERGE Items.t_ItemShared AS t
--USING @t AS s
--ON s.ItemSharedID = t.ID
--WHEN MATCHED THEN
--    UPDATE SET t.SellCurrencyID = s.CurrencyID,
--               t.SellCurrency = s.Currency,
--               t.Sell = s.Price,
--               t.SellF = Currencys.f_Format(s.CurrencyID, s.Price),
--               t.SellD = s.Price / s.ExchangeRate,
--               t.SellLL = Currencys.f_ExchangeToLL(s.CurrencyID, s.Price, s.Price / s.ExchangeRate),
--               t.SellEuro = Currencys.f_ExchangeToEuro(s.CurrencyID, s.Price, s.Price / s.ExchangeRate),
--               t.SellWithTax = s.PriceWithTax,
--               t.SellWithTaxF = Currencys.f_Format(s.CurrencyID, s.PriceWithTax),
--               t.SellWithTaxD = s.PriceWithTax / s.ExchangeRate,
--               t.SellWithTaxLL = Currencys.f_ExchangeToLL(
--                                                             s.CurrencyID,
--                                                             s.PriceWithTax,
--                                                             s.PriceWithTax / s.ExchangeRate
--                                                         ),
--               t.SellWithTaxEuro = Currencys.f_ExchangeToEuro(
--                                                                 s.CurrencyID,
--                                                                 s.PriceWithTax,
--                                                                 s.PriceWithTax / s.ExchangeRate
--                                                             );

--UPDATE Items.t_ItemShared
--SET SellTotal = Sell * QtyCurrent,
--    SellTotalF = Currencys.f_Format(SellCurrencyID, Sell * QtyCurrent),
--    SellTotalD = SellD * QtyCurrent,
--    SellTotalLL = SellLL * QtyCurrent,
--    SellTotalEuro = SellEuro * QtyCurrent,
--    SellTotalWithTax = SellWithTax * QtyCurrent,
--    SellTotalWithTaxF = Currencys.f_Format(SellCurrencyID, SellWithTax * QtyCurrent),
--    SellTotalWithTaxD = SellWithTaxD * QtyCurrent,
--    SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent,
--    SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent;

END;

BEGIN; --22-07-2020

  PRINT '';

--DISABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;

--UPDATE Items.t_ItemShared
--SET PurchaseWithTax = Purchase,
--    PurchaseWithTaxD = PurchaseD,
--    PurchaseWithTaxLL = PurchaseLL,
--    PurchaseWithTaxEuro = PurchaseEuro,
--    SellWithTax = Sell,
--    SellWithTaxD = SellD,
--    SellWithTaxLL = SellLL,
--    SellWithTaxEuro = SellEuro;

--ENABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;

--UPDATE Items.t_ItemShared
--SET Purchase = PurchaseWithTax - ((PurchaseWithTax / (100.0 + TaxRate)) * TaxRate),
--    PurchaseD = PurchaseWithTaxD - ((PurchaseWithTaxD / (100.0 + TaxRate)) * TaxRate),
--    PurchaseLL = PurchaseWithTaxLL - ((PurchaseWithTaxLL / (100.0 + TaxRate)) * TaxRate),
--    PurchaseEuro = PurchaseWithTaxEuro - ((PurchaseWithTaxEuro / (100.0 + TaxRate)) * TaxRate),
--    Sell = SellWithTax - ((SellWithTax / (100.0 + TaxRate)) * TaxRate),
--    SellD = SellWithTaxD - ((SellWithTaxD / (100.0 + TaxRate)) * TaxRate),
--    SellLL = SellWithTaxLL - ((SellWithTaxLL / (100.0 + TaxRate)) * TaxRate),
--    SellEuro = SellWithTaxEuro - ((SellWithTaxEuro / (100.0 + TaxRate)) * TaxRate);

--UPDATE Items.t_UnityItem
--SET PriceWithTax = Price,
--    PriceWithTaxD = PriceD,
--    PriceWithTaxLL = PriceLL,
--    PriceWithTaxEuro = PriceEuro;

--WITH o
--AS (SELECT s.ID,
--           s.CurrencyID,
--           s.Price,
--           s.PriceF,
--           s.PriceD,
--           s.PriceLL,
--           s.PriceEuro,
--           s1.TaxRate,
--           s.PriceWithTax,
--           s.PriceWithTaxF,
--           s.PriceWithTaxD,
--           s.PriceWithTaxLL,
--           s.PriceWithTaxEuro
--    FROM Items.t_UnityItem AS s
--        LEFT JOIN Items.t_ItemShared AS s1
--            ON s1.ID = s.SharedID)
--UPDATE o
--SET o.Price = o.PriceWithTax - ((o.PriceWithTax / (100.0 + o.TaxRate)) * o.TaxRate),
--    o.PriceD = o.PriceWithTaxD - ((o.PriceWithTaxD / (100.0 + o.TaxRate)) * o.TaxRate),
--    o.PriceLL = o.PriceWithTaxLL - ((o.PriceWithTaxLL / (100.0 + o.TaxRate)) * o.TaxRate),
--    o.PriceEuro = o.PriceWithTaxEuro - ((o.PriceWithTaxEuro / (100.0 + o.TaxRate)) * o.TaxRate);

--DECLARE @UserID UNIQUEIDENTIFIER = Users.f_UserGetFirstID();

--EXEC Items.s_ItemSharedRebuildingStatistics @UserID, N'', N'', N'', N'';

END;

BEGIN; --12-07-2020

  PRINT '';

--UPDATE Invoices.t_Sold
--SET SalespersonID = Employees.f_SalesPersonGetFirstID(),
--    Salesperson = Employees.f_SalesPersonGetFirstName()
--WHERE SalespersonID = '00000000-0000-0000-0000-000000000000';

--UPDATE Invoices.t_SoldDetail
--SET SubTotal = Total,
--    SubTotalF = TotalF,
--    SubTotalD = TotalD,
--    SubTotalLL = TotalLL,
--    SubTotalEuro = TotalEuro;

--UPDATE Invoices.t_SoldReturnDetail
--SET SubTotal = Total,
--    SubTotalF = TotalF,
--    SubTotalD = TotalD,
--    SubTotalLL = TotalLL,
--    SubTotalEuro = TotalEuro;

--UPDATE Invoices.t_PurchasingDetail
--SET SubTotal = Total,
--    SubTotalF = TotalF,
--    SubTotalD = TotalD,
--    SubTotalLL = TotalLL,
--    SubTotalEuro = TotalEuro;

--UPDATE Invoices.t_PurchasingReturnDetail
--SET SubTotal = Total,
--    SubTotalF = TotalF,
--    SubTotalD = TotalD,
--    SubTotalLL = TotalLL,
--    SubTotalEuro = TotalEuro;

--UPDATE Quotations.t_QuotationDetail
--SET SubTotal = Total,
--    SubTotalF = TotalF,
--    SubTotalD = TotalD,
--    SubTotalLL = TotalLL,
--    SubTotalEuro = TotalEuro;

--UPDATE Quotations.t_QuotationHistoryDetail
--SET SubTotal = Total,
--    SubTotalF = TotalF,
--    SubTotalD = TotalD,
--    SubTotalLL = TotalLL,
--    SubTotalEuro = TotalEuro;

END;
GO
