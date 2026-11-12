SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_AddressUpdate]
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
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --DECLARE

            DECLARE @OwnerID UNIQUEIDENTIFIER,
                    @SectionID INT,
                    @Return INT;

        END;

        BEGIN --Set info

            SELECT TOP (1)
                   @OwnerID = s.OwnerID,
                   @SectionID = s.SectionID
            FROM Location.t_Address AS s
            WHERE s.ID = @ID
            ORDER BY s.ID;

        END;

        BEGIN --Update

            SET @Return = -2;

            UPDATE Location.t_Address
            SET Name = @Name,
                TypeIs = @TypeIs,
                StatesID = @StatesID,
                StatesIs = Location.f_StatesGetName(@StatesID),
                RegionID = @RegionID,
                RegionIs = Location.f_RegionGetName(@RegionID),
                StreetID = @StreetID,
                Street = Location.f_StreetGetName(@StreetID),
                BuildingID = @BuildingID,
                Building = Location.f_BuildingGetName(@BuildingID),
                FloorID = @FloorID,
                FloorIs = Location.f_FloorGetName(@FloorID),
                PostalCodeID = @PostalCodeID,
                PostalCode = Location.f_PostalCodeGetName(@PostalCodeID),
                AddressNote = @AddressNote
            WHERE ID = @ID;

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
            WHERE ID = @ID;

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

                UPDATE Alls.t_LiveVersion
                SET VersionLive = STUFF(VersionLive, Customer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
                    SchemasIs = STUFF(SchemasIs, SchemaCustomer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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

                UPDATE Alls.t_LiveVersion
                SET VersionLive = STUFF(VersionLive, Vendor, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
                    SchemasIs = STUFF(SchemasIs, SchemaVendor, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
