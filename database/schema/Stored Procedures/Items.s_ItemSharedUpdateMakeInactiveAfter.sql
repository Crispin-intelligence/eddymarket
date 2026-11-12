SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemSharedUpdateMakeInactiveAfter]
    @MakeInactiveAfter INT,
    @MakeInactiveAfterType TINYINT,
    @UserID UNIQUEIDENTIFIER,
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @IDAndEvent Alls.tt_IDAndEvent READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;

        BEGIN --Update 

            SET @Return = 0;

            UPDATE Items.t_ItemShared
            SET MakeInactiveAfter = @MakeInactiveAfter,
                MakeInactiveAfterType = @MakeInactiveAfterType
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDAndEvent AS s WHERE s.ID = t_ItemShared.ID
            );

            UPDATE Items.t_ItemShared
            SET StatusIs = 1
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDAndEvent AS s WHERE s.ID = t_ItemShared.ID
            )
                  AND StatusIs = 0
                  AND MakeInactiveAfter <> 0
                  AND CASE MakeInactiveAfterType
                          WHEN 2 THEN
                              DATEADD(DAY, MakeInactiveAfter, DateLastSale)
                          WHEN 1 THEN
                              DATEADD(MONTH, MakeInactiveAfter, DateLastSale)
                          ELSE
                              DATEADD(YEAR, MakeInactiveAfter, DateLastSale)
                      END < GETDATE();

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Items.t_ItemSharedMoving
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
                   s.EventIs,
                   1,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @IDAndEvent AS s;

        END;

        ENABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;

        BEGIN --Live

            UPDATE Alls.t_LiveVersion
            SET VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
                SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
