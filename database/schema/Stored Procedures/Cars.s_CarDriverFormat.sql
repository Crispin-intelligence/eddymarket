SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Cars].[s_CarDriverFormat] @ID UNIQUEIDENTIFIER
AS
BEGIN

  DECLARE @SectionID INT = 184;

  UPDATE  Cars.t_CarDriver
  SET     ValidDriverLicense = IIF(LicenseExpirationDate >= CONVERT(DATE, GETDATE()), 1, 0) ,
          DrivingLicenseStates = Location.f_StatesGetName(DrivingLicenseStatesID) ,
          DrivingLicenseRegion = Location.f_RegionGetName(DrivingLicenseRegionID) ,
          Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                 WHEN N'' THEN N''
                                                                 ELSE N': ' + t.ExtensionIs
                                                               END AS [text()]
                                   FROM   Company.t_BookPhone AS t
                                   WHERE  t.OwnerID = t_CarDriver.ID
                                          AND t.SectionID = @SectionID
                                 FOR
                                   XML PATH('')
                                 )) ,
          PhonesC = ( SELECT  COUNT(t.ID)
                      FROM    Company.t_BookPhone AS t
                      WHERE   t.OwnerID = t_CarDriver.ID
                              AND t.SectionID = @SectionID
                    ) ,
          SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
                                        FROM    Company.t_SocialMedia AS t
                                        WHERE   t.OwnerID = t_CarDriver.ID
                                                AND t.SectionID = @SectionID
                                      FOR
                                        XML PATH('')
                                      )) ,
          SocialMediaC = ( SELECT COUNT(t.ID)
                           FROM   Company.t_SocialMedia AS t
                           WHERE  t.OwnerID = t_CarDriver.ID
                                  AND t.SectionID = @SectionID
                         ) ,
          Nationality = Employees.f_NationalityGetName(NationalityID) ,
          Title = Customers.f_TitleGetName(TitleID) ,
          Classification = Customers.f_ClassificationGetName(ClassificationID) ,
          BirthdayStates = Location.f_StatesGetName(BirthdayStatesID) ,
          BirthdayRegion = Location.f_RegionGetName(BirthdayRegionID) ,
          AgeIs = DateTimes.f_GetAge(Birthday) ,
          StatesIs = Location.f_StatesGetName(StatesID) ,
          RegionIs = Location.f_RegionGetName(RegionID) ,
          Street = Location.f_StreetGetName(StreetID) ,
          Building = Location.f_BuildingGetName(BuildingID) ,
          FloorIs = Location.f_FloorGetName(FloorID) ,
          PostalCode = Location.f_PostalCodeGetName(PostalCodeID)
  WHERE   ID = @ID;

  UPDATE  Cars.t_CarDriver
  SET     AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
  WHERE   ID = @ID;

END;




GO
