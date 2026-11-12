SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedExecuteJobStatusIs]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check i need execute

            IF NOT EXISTS
            (
                SELECT TOP (1)
                       s.ID
                FROM Alls.t_LastExecuteJob AS s
                WHERE s.Items_ItemShared_StatusIs < CONVERT(DATE, GETDATE())
            )
            BEGIN

                COMMIT TRANSACTION;

                RETURN 1;

            END;

        END;

        DISABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;

        BEGIN; --Update 

            UPDATE Items.t_ItemShared
            SET DaysLastSale = DATEDIFF(DAY, DateLastSale, GETDATE());

            UPDATE Items.t_ItemShared
            SET StatusIs = 1
            WHERE StatusIs = 0
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

        BEGIN --Execute is done

            UPDATE Alls.t_LastExecuteJob
            SET Items_ItemShared_StatusIs = GETDATE();

        END;

        ENABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;

        BEGIN --Live

            UPDATE Alls.t_LiveVersion
            SET VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
                SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

        END;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN 0;

    END CATCH;

END;








GO
