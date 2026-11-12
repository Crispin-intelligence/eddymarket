SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Vendors].[s_VendorRebuildingStatistics]
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

      UPDATE  Vendors.t_Vendor
      SET     Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                     WHEN N'' THEN N''
                                                                     ELSE N': ' + t.ExtensionIs
                                                                   END AS [text()]
                                       FROM   Company.t_BookPhone AS t
                                       WHERE  t.OwnerID = t_Vendor.ID
                                              AND t.SectionID = 67
                                     FOR
                                       XML PATH('')
                                     )) ,
              PhonesC = ( SELECT  COUNT(t.ID)
                          FROM    Company.t_BookPhone AS t
                          WHERE   t.OwnerID = t_Vendor.ID
                                  AND t.SectionID = 67
                        ) ,
              SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
                                            FROM    Company.t_SocialMedia AS t
                                            WHERE   t.OwnerID = t_Vendor.ID
                                                    AND t.SectionID = 67
                                          FOR
                                            XML PATH('')
                                          )) ,
              SocialMediaC = ( SELECT COUNT(t.ID)
                               FROM   Company.t_SocialMedia AS t
                               WHERE  t.OwnerID = t_Vendor.ID
                                      AND t.SectionID = 67
                             ) ,
              Title = Customers.f_TitleGetName(TitleID) ,
              Classification = Customers.f_ClassificationGetName(ClassificationID) ,
              StatesIs = Location.f_StatesGetName(StatesID) ,
              RegionIs = Location.f_RegionGetName(RegionID) ,
              Street = Location.f_StreetGetName(StreetID) ,
              Building = Location.f_BuildingGetName(BuildingID) ,
              FloorIs = Location.f_FloorGetName(FloorID) ,
              PostalCode = Location.f_PostalCodeGetName(PostalCodeID) ,
              AddressC = ( SELECT COUNT(t.ID)
                           FROM   Location.t_Address AS t
                           WHERE  t.OwnerID = t_Vendor.ID
                                  AND t.SectionID = 67
                         ) ,
              CallAfterF = FORMAT(CallAfter, 't');

      UPDATE  Vendors.t_Vendor
      SET     AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-');

      UPDATE  Vendors.t_Vendor
      SET     SearchText = Vendors.f_VendorSearchTextGet(ID);
	 
      WITH  o AS ( SELECT s.Payment ,
                          s.PaymentF ,
                          s.PaymentD ,
                          s1.CurrencyID ,
                          s2.ExchangeRate
                   FROM   Vendors.t_Vendor AS s
                   LEFT JOIN Company.t_Account AS s1 ON s1.SectionID = 67
                                                        AND s1.LinkWithID = s.ID
                   LEFT JOIN Currencys.t_Currency AS s2 ON s2.ID = s1.CurrencyID
                 )
        UPDATE  o
        SET     o.PaymentF = Currencys.f_Format(o.CurrencyID, o.Payment) ,
                o.PaymentD = o.Payment / o.ExchangeRate;

      UPDATE  Company.t_Account
      SET     DeliveryServicesC = [Invoices].f_DeliveryServiceGetCountByAccountCustomerID(ID) ,
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
              QuotationLast = Quotations.[f_QuotationGetLastDateByAccountID](ID)
      WHERE   SectionID = 67
              AND IsMasterLink = 1;

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
              QuotationProfitF = Currencys.f_Format(CurrencyID, QuotationProfit)
      WHERE   SectionID = 67
              AND IsMasterLink = 1;

    END;

    BEGIN --Rebuilding statistics t_VendorSchedulePayment

      UPDATE  Vendors.t_VendorSchedulePayment
      SET     PaymentF = Currencys.f_Format(CurrencyID, Payment) ,
              Currency = Currencys.f_CurrencyGetName(CurrencyID);

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
