SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarExecuteJob]
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
                WHERE s.Cars_Car < CONVERT(DATE, GETDATE())
            )
            BEGIN

                COMMIT TRANSACTION;

                RETURN 1;

            END;

        END;

        BEGIN --Update 

            UPDATE Cars.t_Car
            SET AvailabilityIs = Cars.f_CarGetAvailabilityIsNow(ID);

        END;

        BEGIN --Execute is done

            UPDATE Alls.t_LastExecuteJob
            SET Cars_Car = GETDATE();

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
