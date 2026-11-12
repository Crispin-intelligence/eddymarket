SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_EmployeeRebuildingStatistics]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
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

            UPDATE Employees.t_Employee
            SET AgeIs = DateTimes.f_GetAge(Birthday),
                TypeIs = Employees.f_EmployeeTypeGetName(TypeID),
                Nationality = Employees.f_NationalityGetName(NationalityID),
                StatesIs = Location.f_StatesGetName(StatesID),
                RegionIs = Location.f_RegionGetName(RegionID),
                Street = Location.f_StreetGetName(StreetID),
                Building = Location.f_BuildingGetName(BuildingID),
                FloorIs = Location.f_FloorGetName(FloorID),
                PostalCode = Location.f_PostalCodeGetName(PostalCodeID),
                Currency = Currencys.f_CurrencyGetName(CurrencyID),
                SalaryIsF = Currencys.f_Format(CurrencyID, SalaryIs),
                SalaryDeliveryServiceF = Currencys.f_Format(CurrencyID, SalaryDeliveryService),
                SalaryHoursF = Currencys.f_Format(CurrencyID, SalaryHours),
                VacationAvailableC =
                (
                    SELECT COALESCE(SUM(t.DaysIs), 0)
                    FROM Employees.t_Vacation AS t
                    WHERE t.EmployeeID = t_Employee.ID
                          AND t.OperationType <> 2
                ),
                --TotalExitEntryPermission = COALESCE(
                --                           (
                --                               SELECT SUM(t.Hours)
                --                               FROM Employees.t_ExitEntryPermission AS t
                --                               WHERE t.EmployeeID = t_Employee.ID
                --                           ),
                --                           0
                --                                   ),
                DiscountAvailable =
                (
                    SELECT COALESCE(SUM(   CASE s1.TypeIs
                                               WHEN 0 THEN
                                                   s.ValueIsD
                                               WHEN 1 THEN
                                                   s.ValueIsLL
                                               ELSE
                                                   s.ValueIsEuro
                                           END
                                       ),
                                    0
                                   ) AS DiscountAvailable
                    FROM Employees.t_Discount AS s
                        LEFT JOIN Currencys.t_Currency AS s1
                            ON s1.ID = t_Employee.CurrencyID
                    WHERE s.EmployeeID = t_Employee.ID
                ),
                BonusAvailable =
                (
                    SELECT COALESCE(SUM(   CASE s1.TypeIs
                                               WHEN 0 THEN
                                                   s.ValueIsD
                                               WHEN 1 THEN
                                                   s.ValueIsLL
                                               ELSE
                                                   s.ValueIsEuro
                                           END
                                       ),
                                    0
                                   ) AS BonusAvailable
                    FROM Employees.t_Bonus AS s
                        LEFT JOIN Currencys.t_Currency AS s1
                            ON s1.ID = t_Employee.CurrencyID
                    WHERE s.EmployeeID = t_Employee.ID
                ),
                InWorkNow = Employees.f_EmployeeGetInWorkNow(ID),
                Phones = Alls.f_FixXML(
                         (
                             SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                             WHEN N'' THEN
                                                                 N''
                                                             ELSE
                                                                 N': ' + t.ExtensionIs
                                                         END AS [text()]
                             FROM Company.t_BookPhone AS t
                             WHERE t.OwnerID = t_Employee.ID
                                   AND t.SectionID = 33
                             FOR XML PATH('')
                         )
                                      ),
                PhonesC =
                (
                    SELECT COUNT(t.ID)
                    FROM Company.t_BookPhone AS t
                    WHERE t.OwnerID = t_Employee.ID
                          AND t.SectionID = 33
                ),
                SocialMedia = Alls.f_FixXML(
                              (
                                  SELECT N', ' + t.AccountIs AS [text()]
                                  FROM Company.t_SocialMedia AS t
                                  WHERE t.OwnerID = t_Employee.ID
                                        AND t.SectionID = 33
                                  FOR XML PATH('')
                              )
                                           ),
                SocialMediaC =
                (
                    SELECT COUNT(t.ID)
                    FROM Company.t_SocialMedia AS t
                    WHERE t.OwnerID = t_Employee.ID
                          AND t.SectionID = 33
                );
            --,
            --RequestC =
            --(
            --    SELECT COUNT(*)
            --    FROM Requests.t_Request AS s
            --    WHERE s.EmployeeID = t_Employee.ID
            --) +
            --(
            --    SELECT COUNT(*)
            --    FROM Requests.t_RequestHistory AS s
            --    WHERE s.EmployeeID = t_Employee.ID
            --),
            --FeedbackC =
            --(
            --    SELECT COUNT(*)
            --    FROM Company.t_FeedBack AS s
            --    WHERE s.EmployeeID = t_Employee.ID
            --);

            UPDATE Employees.t_Employee
            SET AddressIs = Location.f_ConcetFullAddress(
                                                            StatesIs,
                                                            RegionIs,
                                                            Street,
                                                            Building,
                                                            FloorIs,
                                                            PostalCode,
                                                            AddressNote,
                                                            ' - ',
                                                            '-'
                                                        ),
                DiscountAvailableF = Currencys.f_Format(CurrencyID, DiscountAvailable),
                BonusAvailableF = Currencys.f_Format(CurrencyID, BonusAvailable);

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
            QuotationLast = Quotations.[f_QuotationGetLastDateByAccountID](ID)
        WHERE SectionID = 33 AND IsMasterLink = 1;

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
            QuotationProfitF = Currencys.f_Format(CurrencyID, QuotationProfit)
        WHERE SectionID = 33 AND IsMasterLink = 1;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Employees.t_EmployeeMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            VALUES
            (@UserID, '00000000-0000-0000-0000-000000000000', @Event, 6, @ComputerIP, @Computer, @ComputerAccount);

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
