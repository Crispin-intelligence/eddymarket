SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_AddressInsert]
    @SectionID INT,
    @OwnerID UNIQUEIDENTIFIER,
    @OwnerName NVARCHAR(MAX),
    @Name NVARCHAR(150),
    @TypeIs TINYINT,
    @StatesID UNIQUEIDENTIFIER,
    @RegionID UNIQUEIDENTIFIER,
    @StreetID UNIQUEIDENTIFIER,
    @BuildingID UNIQUEIDENTIFIER,
    @FloorID UNIQUEIDENTIFIER,
    @PostalCodeID UNIQUEIDENTIFIER,
    @AddressNote NVARCHAR(MAX),
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --DECLARE

            DECLARE @IDs TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL
            );

            DECLARE @Return INT;

        END;

        BEGIN --Insert

            SET @Return = -2;

            INSERT INTO Location.t_Address
            (
                SectionID,
                OwnerID,
                OwnerName,
                Name,
                TypeIs,
                StatesID,
                StatesIs,
                RegionID,
                RegionIs,
                StreetID,
                Street,
                BuildingID,
                Building,
                FloorID,
                FloorIs,
                PostalCodeID,
                PostalCode,
                AddressNote
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@SectionID, @OwnerID, @OwnerName, @Name, @TypeIs, @StatesID, Location.f_StatesGetName(@StatesID),
             @RegionID, Location.f_RegionGetName(@RegionID), @StreetID, Location.f_StreetGetName(@StreetID),
             @BuildingID, Location.f_BuildingGetName(@BuildingID), @FloorID, Location.f_FloorGetName(@FloorID),
             @PostalCodeID, Location.f_PostalCodeGetName(@PostalCodeID), @AddressNote);

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
                                                        )
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Address.ID
            );

        END;

        BEGIN --Insert event and Live

            SET @Return = -1;

            IF @SectionID = 15
            BEGIN

                INSERT INTO Customers.t_CustomerMoving
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
                (@UserID, @OwnerID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

                UPDATE Customers.t_Customer
                SET AddressC += 1
                WHERE ID = @OwnerID;

            END;
            ELSE IF @SectionID = 67
            BEGIN

                INSERT INTO Vendors.t_VendorMoving
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
                (@UserID, @OwnerID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

                UPDATE Vendors.t_Vendor
                SET AddressC += 1
                WHERE ID = @OwnerID;

            END;

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
