SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_FileStorageInsert]
    @Name NVARCHAR(MAX),
    @DescriptionIs NVARCHAR(MAX),
    @FileContent VARBINARY(MAX),
    @TypeIsID UNIQUEIDENTIFIER,
    @FileExtension NVARCHAR(MAX),
    @FileNameIs NVARCHAR(MAX),
    @Size DECIMAL(38, 7),
    @ExpirationDate DATE,
    @NotificationAR NVARCHAR(MAX),
    @NotificationEN NVARCHAR(MAX),
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

            INSERT INTO Company.t_FileStorage
            (
                Name,
                DescriptionIs,
                FileContent,
                TypeIsID,
                TypeIs,
                FileExtension,
                FileNameIs,
                Size,
                SizeF,
                ExpirationDate,
                StopNotification
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@Name, @DescriptionIs, @FileContent, @TypeIsID, Company.f_FileStorageTypeGetName(@TypeIsID),
             @FileExtension, @FileNameIs, @Size, Calculation.SetFormatSize(@Size, N'Bytes'), @ExpirationDate,
             CAST(IIF(@ExpirationDate = CAST(GETDATE() AS DATE), 1, 0) AS BIT));

            SET @ID =
            (
                SELECT TOP (1) ID FROM @IDs ORDER BY ID
            );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_FileStorageMoving
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

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;



GO
