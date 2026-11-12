SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_ContactUpdate]
    @Name NVARCHAR(450),
    @Gender TINYINT,
    @NationalityID UNIQUEIDENTIFIER,
    @TitleID UNIQUEIDENTIFIER,
    @ClassificationID UNIQUEIDENTIFIER,
    @Birthday DATE,
    @StatesID UNIQUEIDENTIFIER,
    @RegionID UNIQUEIDENTIFIER,
    @StreetID UNIQUEIDENTIFIER,
    @BuildingID UNIQUEIDENTIFIER,
    @FloorID UNIQUEIDENTIFIER,
    @PostalCodeID UNIQUEIDENTIFIER,
    @AddressNote NVARCHAR(MAX),
    @DescriptionIs NVARCHAR(MAX),
    @Image IMAGE,
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

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Update

            SET @Return = 0;
            UPDATE Company.t_Contact
            SET Name = @Name,
                Gender = @Gender,
                NationalityID = @NationalityID,
                TitleID = @TitleID,
                ClassificationID = @ClassificationID,
                Birthday = @Birthday,
                StatesID = @StatesID,
                RegionID = @RegionID,
                StreetID = @StreetID,
                BuildingID = @BuildingID,
                FloorID = @FloorID,
                PostalCodeID = @PostalCodeID,
                AddressNote = @AddressNote,
                DescriptionIs = @DescriptionIs,
                ImageIs = @Image
            WHERE ID = @ID;

        END;
		
        BEGIN --Format

            EXECUTE [Company].s_ContactFormat @ID;

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
            (@UserID, @ID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

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
