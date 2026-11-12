SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Employees].[s_BonusTypeInsertDefaultData]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check

            IF EXISTS (SELECT TOP (1) ID FROM Employees.t_BonusType)
            BEGIN

                COMMIT TRAN;

                RETURN 1;

            END;

        END;

        BEGIN --Insert

            INSERT Employees.t_BonusType DEFAULT VALUES;

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
