SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Options].[s_ReportHeaderFooterInsertDefaultData]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check

            IF EXISTS (SELECT TOP (1) ID FROM Options.t_ReportHeaderFooter)
            BEGIN
			
                COMMIT TRAN;

                RETURN 1;

            END;

        END;

        BEGIN --Insert

            INSERT [Options].[t_ReportHeaderFooter]
            DEFAULT VALUES;

            UPDATE Options.t_ReportHeaderFooter
            SET ID = '11111111-1111-1111-1111-111111111111';

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
