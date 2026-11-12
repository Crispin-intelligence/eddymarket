SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_SubCategoryDelete]
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

            DECLARE @Return INT,
                    @MainCategoryID UNIQUEIDENTIFIER,
                    @CountIs BIGINT;

        END;

        BEGIN --Set

            SELECT TOP (1)
                   @MainCategoryID = s.MainCategoryID
            FROM Items.t_SubCategory AS s
            WHERE s.ID = @ID
            ORDER BY s.DateCreate;

            SELECT @CountIs = COUNT(*)
            FROM Items.t_SubCategory AS s
            WHERE s.MainCategoryID = @MainCategoryID;

        END;

        BEGIN --Check

            IF @CountIs <= 1
            BEGIN

                ROLLBACK;

                RETURN 0;

            END;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE FROM Items.t_SubCategory
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Items.t_SubCategoryMoving
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
