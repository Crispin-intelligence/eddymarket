SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_RegionInsertDefaultData]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check

            IF EXISTS (SELECT TOP (1) ID FROM Location.t_Region)
            BEGIN
			
                COMMIT TRAN;

                RETURN 1;

            END;

        END;

        BEGIN --Insert

            EXECUTE [Location].[s_StatesInsertDefaultData];

            INSERT Location.t_Region
            DEFAULT VALUES;

        END;

        COMMIT TRAN;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN 0;

    END CATCH;

END;





GO
