SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_ContactInsert]
    @Name NVARCHAR(450),
    @Phones Company.td_BookPhone READONLY,
    @SocialMedia Company.dt_SocialMedia READONLY,
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
    @ID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @IDs TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL
            );

            DECLARE @Return INT;

        END;

        BEGIN --Insert

            SET @Return = 0;

            INSERT INTO Company.t_Contact
            (
                Name,
                Gender,
                NationalityID,
                TitleID,
                ClassificationID,
                Birthday,
                StatesID,
                RegionID,
                StreetID,
                BuildingID,
                FloorID,
                PostalCodeID,
                AddressNote,
                DescriptionIs,
                ImageIs
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@Name, @Gender, @NationalityID, @TitleID, @ClassificationID, @Birthday, @StatesID, @RegionID, @StreetID,
             @BuildingID, @FloorID, @PostalCodeID, @AddressNote, @DescriptionIs, @Image);

            SET @ID =
            (
                SELECT TOP (1) ID FROM @IDs ORDER BY ID
            );

        END;

        BEGIN --Insert phones

            SET @Return = -2;

            INSERT INTO Company.t_BookPhone
            (
                OwnerID,
                NumberIs,
                SectionID,
                NumberType,
                LanguageCodeID,
                ExtensionIs
            )
            SELECT DISTINCT
                   @ID,
                   t.NumberIs,
                   153,
                   t.TypeIs,
                   t.LanguageCodeID,
                   t.ExtensionIs
            FROM @Phones AS t;

        END;

        BEGIN --Insert social media

            SET @Return = -4;

            INSERT INTO Company.t_SocialMedia
            (
                OwnerID,
                AccountIs,
                SectionID,
                TypeID
            )
            SELECT @ID,
                   t.AccountIs,
                   153,
                   t.TypeID
            FROM @SocialMedia AS t;

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
            (@UserID, @ID, @Event, 0, @ComputerIP, @Computer, @ComputerAccount);

        END;

        COMMIT TRANSACTION;

        SELECT 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT @Return;

    END CATCH;

END;






GO
