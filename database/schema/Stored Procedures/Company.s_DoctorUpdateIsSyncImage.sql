SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Company].[s_DoctorUpdateIsSyncImage]
    @IsSyncImage BIT,
    @ImagePath NVARCHAR(MAX),
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

		DISABLE TRIGGER Company.tr_Doctor ON Company.t_Doctor;

        BEGIN --Insert

            UPDATE Company.t_Doctor
            SET IsSyncImage = @IsSyncImage,
                ImagePath = @ImagePath
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Company.tr_Doctor ON Company.t_Doctor;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_DoctorMoving
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
            (@UserID, @ID, @Event, 8, @ComputerIP, @Computer, @ComputerAccount);

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
