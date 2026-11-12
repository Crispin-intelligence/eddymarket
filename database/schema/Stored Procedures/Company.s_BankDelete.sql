SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_BankDelete]
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
        BEGIN TRANSACTION BankDelete;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Delete account

            SET @Return = -3;

            DELETE FROM Company.t_Account
            WHERE SectionID = 38
                  AND LinkWithID = @ID;

        END;

        BEGIN --Delete phones 

            DELETE FROM Company.t_BookPhone
            WHERE SectionID = 38
                  AND OwnerID = @ID;

        END;

        BEGIN --Delete SocialMedia 

            DELETE FROM Company.t_SocialMedia
            WHERE SectionID = 38
                  AND OwnerID = @ID;

        END;

        BEGIN --Delete File Storage Linked 

            DELETE FROM Company.t_FileStorageLinked
            WHERE SectionID = 38
                  AND OwnerID = @ID;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE FROM Company.t_Bank
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_BankMoving
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

        COMMIT TRANSACTION BankDelete;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK TRANSACTION BankDelete;

        RETURN @Return;

    END CATCH;

END;












GO
