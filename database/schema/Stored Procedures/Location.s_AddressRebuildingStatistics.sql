SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_AddressRebuildingStatistics]
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

            UPDATE Location.t_Address
            SET StatesIs = Location.f_StatesGetName(StatesID),
                RegionIs = Location.f_RegionGetName(RegionID),
                Street = Location.f_StreetGetName(StreetID),
                Building = Location.f_BuildingGetName(BuildingID),
                FloorIs = Location.f_FloorGetName(FloorID),
                PostalCode = Location.f_PostalCodeGetName(PostalCodeID);

            UPDATE Location.t_Address
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

            UPDATE Location.t_Address
            SET OwnerName = Customers.f_CustomerGetName(OwnerID)
            WHERE SectionID = 15;

            UPDATE Location.t_Address
            SET OwnerName = Vendors.f_VendorGetName(OwnerID)
            WHERE SectionID = 67;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Location.t_StatesMoving
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
