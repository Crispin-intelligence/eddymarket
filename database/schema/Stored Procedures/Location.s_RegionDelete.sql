SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_RegionDelete]
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

            DECLARE @StatesID UNIQUEIDENTIFIER,
                    @RegionCount INT,
                    @Return INT;

        END;

        BEGIN --Set

            SELECT TOP (1)
                   @StatesID = s.StatesID
            FROM Location.t_Region AS s
            WHERE s.ID = @ID
            ORDER BY s.DateCreate;

            SELECT @RegionCount = COUNT(*)
            FROM Location.t_Region AS s
            WHERE s.StatesID = @StatesID;

        END;

        BEGIN --Check

            IF @RegionCount <= 1
            BEGIN

                ROLLBACK;

                RETURN 0;

            END;

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
            WHERE s.RegionID = @ID;

            DELETE FROM Location.t_Street
            WHERE RegionID = @ID;

        END;

        BEGIN --Delete

            DELETE FROM Location.t_Region
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

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
            VALUES
            (@UserID, @ID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount);

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
