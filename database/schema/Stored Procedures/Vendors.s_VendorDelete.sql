SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Vendors].[s_VendorDelete]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @EventType TINYINT,
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION VendorDelete;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Delete account

            SET @Return = -3;

            DELETE FROM Company.t_Account
            WHERE SectionID = 67
                  AND LinkWithID = @ID;

        END;

        BEGIN --Delete phones 

            DELETE FROM Company.t_BookPhone
            WHERE SectionID = 67
                  AND OwnerID = @ID;

        END;

        BEGIN --Delete SocialMedia 

            DELETE FROM Company.t_SocialMedia
            WHERE SectionID = 67
                  AND OwnerID = @ID;

        END;

        BEGIN --Delete File Storage Linked 

            DELETE FROM Company.t_FileStorageLinked
            WHERE SectionID = 67
                  AND OwnerID = @ID;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE FROM Vendors.t_Vendor
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

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
            (@UserID, @ID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount);

        END;

        COMMIT TRANSACTION VendorDelete;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK TRANSACTION VendorDelete;

        RETURN @Return;

    END CATCH;

END;













GO
