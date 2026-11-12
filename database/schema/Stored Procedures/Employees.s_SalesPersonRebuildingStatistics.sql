SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_SalesPersonRebuildingStatistics]
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

      UPDATE  Employees.t_SalesPerson
      SET     CommissionAvailableValueD = ( SELECT  COALESCE(SUM(s.CommissionAvailableValueD), 0)
                                            FROM    Invoices.t_Sold AS s
                                            WHERE   s.SalespersonID = t_SalesPerson.ID
                                          ) ,
              CommissionAvailableValueLL = ( SELECT COALESCE(SUM(s.CommissionAvailableValueLL), 0)
                                             FROM   Invoices.t_Sold AS s
                                             WHERE  s.SalespersonID = t_SalesPerson.ID
                                           ) ,
              CommissionAvailableValueEuro = ( SELECT COALESCE(SUM(s.CommissionAvailableValueEuro), 0)
                                               FROM   Invoices.t_Sold AS s
                                               WHERE  s.SalespersonID = t_SalesPerson.ID
                                             ) ,
              Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                     WHEN N'' THEN N''
                                                                     ELSE N': ' + t.ExtensionIs
                                                                   END AS [text()]
                                       FROM   Company.t_BookPhone AS t
                                       WHERE  t.OwnerID = t_SalesPerson.ID
                                              AND t.SectionID = 149
                                     FOR
                                       XML PATH('')
                                     )) ,
              PhonesC = ( SELECT  COUNT(t.ID)
                          FROM    Company.t_BookPhone AS t
                          WHERE   t.OwnerID = t_SalesPerson.ID
                                  AND t.SectionID = 149
                        ) ,
              SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
                                            FROM    Company.t_SocialMedia AS t
                                            WHERE   t.OwnerID = t_SalesPerson.ID
                                                    AND t.SectionID = 149
                                          FOR
                                            XML PATH('')
                                          )) ,
              SocialMediaC = ( SELECT COUNT(t.ID)
                               FROM   Company.t_SocialMedia AS t
                               WHERE  t.OwnerID = t_SalesPerson.ID
                                      AND t.SectionID = 149
                             ) ,
              StatesIs = Location.f_StatesGetName(StatesID) ,
              RegionIs = Location.f_RegionGetName(RegionID) ,
              Street = Location.f_StreetGetName(StreetID) ,
              Building = Location.f_BuildingGetName(BuildingID) ,
              FloorIs = Location.f_FloorGetName(FloorID) ,
              PostalCode = Location.f_PostalCodeGetName(PostalCodeID) ,
              CommissionRateF = FORMAT(CommissionRate, '0.##') + ' %' ,
              CustomerC = ( SELECT  COUNT(*)
                            FROM    Customers.t_Customer AS s
                            WHERE   s.SalesPersonID = t_SalesPerson.ID
                          );

      UPDATE  Employees.t_SalesPerson
      SET     CommissionAvailableValueDF = Currencys.f_FormatD(CommissionAvailableValueD) ,
              CommissionAvailableValueLLF = Currencys.f_FormatD(CommissionAvailableValueLL) ,
              CommissionAvailableValueEuroF = Currencys.f_FormatD(CommissionAvailableValueEuro) ,
              AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-');

      UPDATE  Employees.t_SalesPerson
      SET     SearchText = Employees.f_SalesPersonSearchTextGet(ID);

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
      WHERE   SectionID = 149
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
      WHERE   SectionID = 149
              AND IsMasterLink = 1;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Employees.t_SalesPersonMoving
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
