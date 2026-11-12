SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_ContactExecuteJobAgeIs]
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
                WHERE s.Company_Contact_AgeIs < CONVERT(DATE, GETDATE())
            )
            BEGIN

                COMMIT TRANSACTION;

                RETURN 1;

            END;

        END;

        BEGIN --Update 

            UPDATE Company.t_Contact
            SET AgeIs = DateTimes.f_GetAge(Birthday);

        END;

        BEGIN --Execute is done

            UPDATE Alls.t_LastExecuteJob
            SET Company_Contact_AgeIs = GETDATE();

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
