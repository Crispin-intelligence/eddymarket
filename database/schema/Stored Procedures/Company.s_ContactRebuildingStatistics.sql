SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_ContactRebuildingStatistics]
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

            UPDATE Company.t_Contact
            SET Phones = Alls.f_FixXML(
                         (
                             SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                             WHEN N'' THEN
                                                                 N''
                                                             ELSE
                                                                 N': ' + t.ExtensionIs
                                                         END AS [text()]
                             FROM Company.t_BookPhone AS t
                             WHERE t.OwnerID = t_Contact.ID
                                   AND t.SectionID = 153
                             FOR XML PATH('')
                         )
                                      ),
                PhonesC =
                (
                    SELECT COUNT(t.ID)
                    FROM Company.t_BookPhone AS t
                    WHERE t.OwnerID = t_Contact.ID
                          AND t.SectionID = 153
                ),
                SocialMedia = Alls.f_FixXML(
                              (
                                  SELECT N', ' + t.AccountIs AS [text()]
                                  FROM Company.t_SocialMedia AS t
                                  WHERE t.OwnerID = t_Contact.ID
                                        AND t.SectionID = 153
                                  FOR XML PATH('')
                              )
                                           ),
                SocialMediaC =
                (
                    SELECT COUNT(t.ID)
                    FROM Company.t_SocialMedia AS t
                    WHERE t.OwnerID = t_Contact.ID
                          AND t.SectionID = 153
                ),
                Nationality = Employees.f_NationalityGetName(NationalityID),
                Title = Customers.f_TitleGetName(TitleID),
                Classification = Customers.f_ClassificationGetName(ClassificationID),
                AgeIs = DateTimes.f_GetAge(Birthday),
                StatesIs = Location.f_StatesGetName(StatesID),
                RegionIs = Location.f_RegionGetName(RegionID),
                Street = Location.f_StreetGetName(StreetID),
                Building = Location.f_BuildingGetName(BuildingID),
                FloorIs = Location.f_FloorGetName(FloorID),
                PostalCode = Location.f_PostalCodeGetName(PostalCodeID);

            UPDATE Company.t_Contact
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
                                                        );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_ContactMoving
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
