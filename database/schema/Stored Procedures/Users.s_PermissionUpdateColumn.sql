SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Users].[s_PermissionUpdateColumn]
    @ColumnName NVARCHAR(MAX),
    @HavePermission BIT,
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT,
                    @SceripIs NVARCHAR(MAX);

        END;

        BEGIN --Update

            SET @Return = 0;

            SET @SceripIs
                = 'update users.t_Permission set ' + @ColumnName + ' = ' + CONVERT(NVARCHAR(MAX), @HavePermission)
                  + ' where ID = ''' + CONVERT(NVARCHAR(MAX), @ID) + '''';

            EXECUTE (@SceripIs);

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
            (@UserID, @ID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

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
