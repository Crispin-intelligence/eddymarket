SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_EmployeeFormat] @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Rebuilding statistics

      UPDATE  Employees.t_Employee
      SET     AgeIs = DateTimes.f_GetAge(Birthday) ,
              TypeIs = Employees.f_EmployeeTypeGetName(TypeID) ,
              Nationality = Employees.f_NationalityGetName(NationalityID) ,
              StatesIs = Location.f_StatesGetName(StatesID) ,
              RegionIs = Location.f_RegionGetName(RegionID) ,
              Street = Location.f_StreetGetName(StreetID) ,
              Building = Location.f_BuildingGetName(BuildingID) ,
              FloorIs = Location.f_FloorGetName(FloorID) ,
              PostalCode = Location.f_PostalCodeGetName(PostalCodeID) ,
              Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
              SalaryIsF = Currencys.f_Format(CurrencyID, SalaryIs) ,
              SalaryDeliveryServiceF = Currencys.f_Format(CurrencyID, SalaryDeliveryService) ,
              SalaryHoursF = Currencys.f_Format(CurrencyID, SalaryHours) ,
                --TotalExitEntryPermission = COALESCE(
                --                           (
                --                               SELECT SUM(t.Hours)
                --                               FROM Employees.t_ExitEntryPermission AS t
                --                               WHERE t.EmployeeID = t_Employee.ID
                --                           ),
                --                           0
                --                                   ),
                --DiscountAvailableD = COALESCE(
                --                     (
                --                         SELECT SUM(t.ValueIsD)
                --                         FROM Employees.t_Discount AS t
                --                         WHERE t.EmployeeID = t_Employee.ID
                --                     ),
                --                     0
                --                             ),
              Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                     WHEN N'' THEN N''
                                                                     ELSE N': ' + t.ExtensionIs
                                                                   END AS [text()]
                                       FROM   Company.t_BookPhone AS t
                                       WHERE  t.OwnerID = t_Employee.ID
                                              AND t.SectionID = 33
                                     FOR
                                       XML PATH('')
                                     )) ,
              PhonesC = ( SELECT  COUNT(t.ID)
                          FROM    Company.t_BookPhone AS t
                          WHERE   t.OwnerID = t_Employee.ID
                                  AND t.SectionID = 33
                        ) ,
              SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
                                            FROM    Company.t_SocialMedia AS t
                                            WHERE   t.OwnerID = t_Employee.ID
                                                    AND t.SectionID = 33
                                          FOR
                                            XML PATH('')
                                          )) ,
              SocialMediaC = ( SELECT COUNT(t.ID)
                               FROM   Company.t_SocialMedia AS t
                               WHERE  t.OwnerID = t_Employee.ID
                                      AND t.SectionID = 33
                             )
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
      WHERE   ID = @ID;

      UPDATE  Employees.t_Employee
      SET     AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
      WHERE   ID = @ID;

      UPDATE  Employees.t_Employee
      SET     SearchText = Employees.f_EmployeeSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    COMMIT TRAN;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN 0;

  END CATCH;

END;




GO
