SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_FloorDelete]
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
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE FROM Location.t_Floor
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Location.t_FloorMoving
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

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;







GO
