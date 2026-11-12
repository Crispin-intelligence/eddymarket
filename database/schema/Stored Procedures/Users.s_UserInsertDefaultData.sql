SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Users].[s_UserInsertDefaultData]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check

            IF EXISTS (SELECT TOP (1) ID FROM Users.t_User)
            BEGIN
			
                COMMIT TRAN;

                RETURN 1;

            END;

        END;

        BEGIN --Insert

            EXECUTE Users.s_PermissionInsertDefaultData;

            INSERT INTO Users.t_User
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
