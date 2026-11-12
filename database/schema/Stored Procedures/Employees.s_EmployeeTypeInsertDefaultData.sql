SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_EmployeeTypeInsertDefaultData]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check

            IF EXISTS (SELECT TOP (1) ID FROM Employees.t_EmployeeType)
            BEGIN
			
                COMMIT TRAN;

                RETURN 1;

            END;

        END;

        BEGIN --Insert

            INSERT Employees.t_EmployeeType
            (
                Name
            )
            VALUES
            (N'-');

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
