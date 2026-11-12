SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Users].[s_PermissionRebuildingStatistics]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Rebuild statistics

            SET @Return = 0;

            UPDATE Users.t_Permission
            SET TrueC = Users.f_PermissionGetCountPermission(ID, 1),
                FalseC = Users.f_PermissionGetCountPermission(ID, 0);

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Users.t_PermissionMoving
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
            (@UserID, '00000000-0000-0000-0000-000000000000', @Event, 6, @ComputerIP, @Computer, @ComputerAccount);

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
