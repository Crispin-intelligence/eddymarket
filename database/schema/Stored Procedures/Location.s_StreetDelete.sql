SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_StreetDelete]
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

            DECLARE @RegionID UNIQUEIDENTIFIER,
                    @StreetCount INT,
                    @Return INT;

        END;

        BEGIN --Set

            SELECT TOP (1)
                   @RegionID = s.RegionID
            FROM Location.t_Street AS s
            WHERE s.ID = @ID
            ORDER BY s.DateCreate;

            SELECT @StreetCount = COUNT(*)
            FROM Location.t_Street AS s
            WHERE s.RegionID = @RegionID;

        END;

        BEGIN --Check

            IF @StreetCount <= 1
            BEGIN

                ROLLBACK;

                RETURN 0;

            END;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE FROM Location.t_Street
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

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
