SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerFormat] @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Rebuilding statistics

      UPDATE  Customers.t_Customer
      SET     Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                     WHEN N'' THEN N''
                                                                     ELSE N': ' + t.ExtensionIs
                                                                   END AS [text()]
                                       FROM   Company.t_BookPhone AS t
                                       WHERE  t.OwnerID = t_Customer.ID
                                              AND t.SectionID = 15
                                     FOR
                                       XML PATH('')
                                     )) ,
              PhonesC = ( SELECT  COUNT(t.ID)
                          FROM    Company.t_BookPhone AS t
                          WHERE   t.OwnerID = t_Customer.ID
                                  AND t.SectionID = 15
                        ) ,
              SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
                                            FROM    Company.t_SocialMedia AS t
                                            WHERE   t.OwnerID = t_Customer.ID
                                                    AND t.SectionID = 15
                                          FOR
                                            XML PATH('')
                                          )) ,
              SocialMediaC = ( SELECT COUNT(t.ID)
                               FROM   Company.t_SocialMedia AS t
                               WHERE  t.OwnerID = t_Customer.ID
                                      AND t.SectionID = 15
                             ) ,
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
              CallAfterF = FORMAT(CallAfter, 't')
      WHERE   ID = @ID;

      UPDATE  Customers.t_Customer
      SET     AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
      WHERE   ID = @ID;

      UPDATE  Customers.t_Customer
      SET     SearchText = Customers.f_CustomerSearchTextGet(ID)
      WHERE   ID = @ID;
	  
    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN 0;

  END CATCH;

END;








GO
