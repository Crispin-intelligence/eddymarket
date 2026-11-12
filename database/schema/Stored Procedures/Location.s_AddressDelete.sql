SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_AddressDelete]
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

            DELETE FROM Location.t_Address
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

                UPDATE Customers.t_Customer
                SET AddressC -= 1
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
                SET AddressC -= 1
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
