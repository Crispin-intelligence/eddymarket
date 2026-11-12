SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Customers].[s_CustomerRebuildingStatistics] @LicenseInternet BIT ,
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

    BEGIN --Rebuilding statistics

      SET @Return = 0;

      UPDATE Customers.t_Customer
        SET Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                   WHEN N'' THEN N''
                                                                   ELSE N': ' + t.ExtensionIs
                                                                 END AS [text()]
                                      FROM Company.t_BookPhone AS t
                                      WHERE t.OwnerID = t_Customer.ID AND t.SectionID = 15
                                   FOR
                                     XML PATH('')
                                   )) ,
            PhonesC = ( SELECT COUNT(t.ID)
                          FROM Company.t_BookPhone AS t
                          WHERE t.OwnerID = t_Customer.ID AND t.SectionID = 15
                      ) ,
            SocialMedia = Alls.f_FixXML(( SELECT N', ' + t.AccountIs AS [text()]
                                            FROM Company.t_SocialMedia AS t
                                            WHERE t.OwnerID = t_Customer.ID AND t.SectionID = 15
                                        FOR
                                          XML PATH('')
                                        )) ,
            SocialMediaC = ( SELECT COUNT(t.ID)
                              FROM Company.t_SocialMedia AS t
                              WHERE t.OwnerID = t_Customer.ID AND t.SectionID = 15
                           ) ,
            AgeIs = DateTimes.f_GetAge(Birthday) ,
            AgeRange = Customers.f_AgeRangeGetName(AgeRangeID) ,
            Title = Customers.f_TitleGetName(TitleID) ,
            Classification = Customers.f_ClassificationGetName(ClassificationID) ,
            SalesPerson = Employees.f_SalesPersonGetName(SalesPersonID) ,
            Nationality = Employees.f_NationalityGetName(NationalityID) ,
            StatesIs = Location.f_StatesGetName(StatesID) ,
            RegionIs = Location.f_RegionGetName(RegionID) ,
            Street = Location.f_StreetGetName(StreetID) ,
            Building = Location.f_BuildingGetName(BuildingID) ,
            FloorIs = Location.f_FloorGetName(FloorID) ,
            PostalCode = Location.f_PostalCodeGetName(PostalCodeID) ,
            AddressC = ( SELECT COUNT(t.ID)
                          FROM Location.t_Address AS t
                          WHERE t.OwnerID = t_Customer.ID AND t.SectionID = 15
                       ) ,
            CallAfterF = FORMAT(CallAfter, 't') ,
            LicenseInternet = @LicenseInternet ,
            EmployeeInternet = Employees.f_EmployeeGetName(EmployeeIDInternet) ,
            InternetPackage = Customers.f_InternetPackageGetName(InternetPackageID) ,
            ActiveToInternet = COALESCE(( SELECT MAX(s.ActiveTo)
                                            FROM ( SELECT s1.ActiveTo ,
                                                      s1.CustomerID
                                                    FROM Invoices.t_InternetSubscription AS s1
                                                   UNION ALL
                                                   SELECT s1.ActiveTo ,
                                                      s1.CustomerID
                                                    FROM Invoices.t_InternetSubscriptionHistory AS s1
                                                 ) AS s
                                            WHERE s.CustomerID = t_Customer.ID
                                        ), StartFromInternet) ,
            NotificationARInternet = 'سينتهي إشتراك الإنترنت قريبا: ' ,
            NotificationENInternet = 'Internet Subscription Will End Soon: ' ,
            InternetSubscriptionC = [Invoices].f_InternetSubscriptionGetCountByCustomerID(ID) ,
            InternetSubscriptionTotal = [Invoices].[f_InternetSubscriptionGetTotalByCustomerID](ID) ,
            InternetSubscriptionProfit = [Invoices].[f_InternetSubscriptionGetProfitByCustomerID](ID) ,
            InternetSubscriptionLast = [Invoices].f_InternetSubscriptionGetLastDateByCustomerID(ID) ,
            MaximumDebtInvoiceCurrency = Currencys.f_CurrencyGetName(MaximumDebtInvoiceCurrencyID) ,
            MaximumDebtInvoiceF = Currencys.f_Format(MaximumDebtInvoiceCurrencyID, MaximumDebtInvoice) ,
            MaximumDebtInvoiceD = MaximumDebtInvoice / Currencys.f_CurrencyGetExchangeRate(MaximumDebtInvoiceCurrencyID) ,
            GroupNames = Alls.f_FixXML(( SELECT N', ' + t1.Name AS [text()]
                                          FROM Customers.t_CustomerGroupDetail AS t
                                          LEFT JOIN Customers.t_CustomerGroup AS t1 ON t1.ID = t.CustomerGroupID
                                          WHERE t.CustomerID = t_Customer.ID
                                       FOR
                                         XML PATH('')
                                       )) ,
            GroupCounts = ( SELECT COUNT(t.ID)
                              FROM Customers.t_CustomerGroupDetail AS t
                              WHERE t.CustomerID = t_Customer.ID
                          ) ,
            PrescriptionC = ( SELECT COUNT(t.ID)
                                FROM Customers.t_Prescription AS t
                                WHERE t.CustomerID = t_Customer.ID
                            ) ,
            PrescriptionLastDate = COALESCE(( SELECT TOP ( 1 ) t.DateIs
                                                FROM Customers.t_Prescription AS t
                                                WHERE t.CustomerID = t_Customer.ID
                                                ORDER BY t.DateIs DESC
                                            ), DATEFROMPARTS(2000, 1, 1)) ,
            FrameJobOrderC = Customers.f_FrameJobOrderGetCountByCustomerID(ID) ,
            FrameJobOrderTotal = Customers.[f_FrameJobOrderGetTotalByCustomerID](ID) ,
            FrameJobOrderProfit = Customers.[f_FrameJobOrderGetProfitByCustomerID](ID) ,
            FrameJobOrderLast = Customers.f_FrameJobOrderGetLastDateByCustomerID(ID);

      UPDATE Customers.t_Customer
        SET AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-') ,
            NotificationDateInternet = DATEADD(DAY, 0 - NotificationBeforeDaysInternet, ActiveToInternet) ,
            ActiveToDayInternet = DAY(ActiveToInternet);

      WITH  o AS ( SELECT s1.CurrencyID ,
                      s.InternetSubscriptionTotal ,
                      s.InternetSubscriptionTotalF ,
                      s.InternetSubscriptionProfit ,
                      s.InternetSubscriptionProfitF ,
                      s.FrameJobOrderTotal ,
                      s.FrameJobOrderTotalF ,
                      s.FrameJobOrderProfit ,
                      s.FrameJobOrderProfitF
                    FROM Customers.t_Customer AS s
                    INNER JOIN Company.t_Account AS s1 ON s1.LinkWithID = s.ID AND s1.IsMasterLink = 1 AND s1.SectionID = 15
                 )
        UPDATE o
          SET o.InternetSubscriptionTotalF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionTotal) ,
              o.InternetSubscriptionProfitF = Currencys.f_Format(o.CurrencyID, o.InternetSubscriptionProfit) ,
              o.FrameJobOrderTotalF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderTotal) ,
              o.FrameJobOrderProfitF = Currencys.f_Format(o.CurrencyID, o.FrameJobOrderProfit);

      UPDATE  Customers.t_Customer
      SET     SearchText = Customers.f_CustomerSearchTextGet(ID);
	  
      UPDATE Company.t_Account
        SET DeliveryServicesC = [Invoices].f_DeliveryServiceGetCountByAccountCustomerID(ID) ,
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
            GymSubscriptionActiveTo = [Gym].f_GymSubscriptionGetActiveToByAccountID(ID)
        WHERE SectionID = 15 AND IsMasterLink = 1;

      UPDATE Company.t_Account
        SET DeliveryServicesTotalF = Currencys.f_Format(CurrencyID, DeliveryServicesTotal) ,
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
            GymSubscriptionIsActive = IIF(GymSubscriptionActiveTo >= CONVERT(DATE, GETDATE()), 1, 0)
        WHERE SectionID = 15 AND IsMasterLink = 1;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Customers.t_CustomerMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        VALUES
          ( @UserID ,
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
