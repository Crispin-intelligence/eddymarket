SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_MainCategoryDelete]
    @SubCategoryEvent NVARCHAR(MAX),
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

            DECLARE @SubCategory TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                Name NVARCHAR(MAX) NOT NULL
            );

            DECLARE @Return INT;

        END;

        BEGIN --Set

            INSERT INTO @SubCategory
            (
                ID,
                Name
            )
            SELECT s.ID,
                   s.Name
            FROM Items.t_SubCategory AS s
            WHERE s.MainCategoryID = @ID;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE FROM Items.t_SubCategory
            WHERE MainCategoryID = @ID;

            DELETE FROM Items.t_MainCategory
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Items.t_MainCategoryMoving
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

        BEGIN --Insert event SubCategory

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
            SELECT @UserID,
                   s.ID,
                   @SubCategoryEvent + ': ' + s.Name,
                   @EventType,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @SubCategory AS s;

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
