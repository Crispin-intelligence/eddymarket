SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_StatesDelete]
    @EventBase NVARCHAR(MAX),
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

            DECLARE @Street AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                Name NVARCHAR(MAX) NOT NULL
            );

            DECLARE @Region AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                Name NVARCHAR(MAX) NOT NULL
            );

            DECLARE @Return INT;

        END;

        BEGIN --Delete street

            SET @Return = 0;

            INSERT @Street
            (
                ID,
                Name
            )
            SELECT s.ID,
                   s.Name
            FROM Location.t_Street AS s
            WHERE s.StatesID = @ID;

            DELETE FROM Location.t_Street
            WHERE StatesID = @ID;

        END;

        BEGIN --Delete Region

            INSERT @Region
            (
                ID,
                Name
            )
            SELECT s.ID,
                   s.Name
            FROM Location.t_Region AS s
            WHERE s.StatesID = @ID;

            DELETE FROM Location.t_Region
            WHERE StatesID = @ID;

        END;

        BEGIN --Delete

            DELETE FROM Location.t_States
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Location.t_StatesMoving
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

        BEGIN --Insert event Region

            INSERT INTO Location.t_RegionMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            SELECT @UserID,
                   s.ID,
                   @EventBase + s.Name,
                   @EventType,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @Region AS s;

        END;

        BEGIN --Insert event Street

            INSERT INTO Location.t_StreetMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            SELECT @UserID,
                   s.ID,
                   @EventBase + s.Name,
                   @EventType,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @Street AS s;

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
