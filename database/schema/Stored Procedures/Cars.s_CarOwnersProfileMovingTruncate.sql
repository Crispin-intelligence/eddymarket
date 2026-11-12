SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarOwnersProfileMovingTruncate]
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

        BEGIN --Delete

            SET @Return = 0;

            TRUNCATE TABLE Cars.t_CarOwnersProfileMoving;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Cars.t_CarOwnersProfileMoving
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
            (@UserID, '00000000-0000-0000-0000-000000000000', @Event, 4, @ComputerIP, @Computer, @ComputerAccount);

        END;

        BEGIN --Live

            UPDATE Alls.t_LiveVersion
            SET VersionLive = STUFF(VersionLive, CarOwnersProfile, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
                SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
