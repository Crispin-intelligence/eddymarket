SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarDriverRebuildingStatistics]
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

      DECLARE @SectionID INT = 184 ,
        @Return INT = 0;

    END;

    DISABLE TRIGGER Cars.tr_CarDriver ON Cars.t_CarDriver;

    BEGIN --Rebuild statistics

      UPDATE  Cars.t_CarDriver
      SET     ValidDriverLicense = IIF(LicenseExpirationDate >= CONVERT(DATE, GETDATE()), 1, 0) ,
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
                                  AND t.SectionID = 184
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
              AgeIs = DateTimes.f_GetAge(Birthday) ,
              StatesIs = Location.f_StatesGetName(StatesID) ,
              RegionIs = Location.f_RegionGetName(RegionID) ,
              Street = Location.f_StreetGetName(StreetID) ,
              Building = Location.f_BuildingGetName(BuildingID) ,
              FloorIs = Location.f_FloorGetName(FloorID) ,
              PostalCode = Location.f_PostalCodeGetName(PostalCodeID) ,
              CarRentalCount = ( SELECT COUNT(*)
                                 FROM   Cars.t_CarRentalDriver AS s
                                 INNER JOIN Cars.t_CarRental AS s1 ON s1.ID = s.CarRentalID
                                 WHERE  s.CarDriverID = t_CarDriver.ID
                                        AND s1.StatusIs <> 3
                               ) + ( SELECT COUNT(*)
                                     FROM   Cars.t_CarRentalHistoryDriver AS s
                                     INNER JOIN Cars.t_CarRentalHistory AS s1 ON s1.ID = s.CarRentalHistoryID
                                     WHERE  s.CarDriverID = t_CarDriver.ID
                                            AND s1.StatusIs <> 3
                                   );

      UPDATE  Cars.t_CarDriver
      SET     AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-');

    END;

    ENABLE TRIGGER Cars.tr_CarDriver ON Cars.t_CarDriver;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarDriverMoving
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

    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, CarDriver, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
