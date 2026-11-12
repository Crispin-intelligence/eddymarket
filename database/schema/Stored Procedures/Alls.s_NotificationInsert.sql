SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_NotificationInsert]
    @TextIs NVARCHAR(450),
    @DateIs DATE,
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @IDs TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL
            );

            DECLARE @Ref BIGINT,
                    @Return INT;

        END;

        BEGIN --Set info

            SELECT @Ref = COALESCE(MAX(s.Ref), 0) + 1
            FROM Alls.t_Notification AS s;

        END;

        BEGIN --Insert

            SET @Return = 0;

            INSERT INTO Alls.t_Notification
            (
                Ref,
                RefF,
                TextIs,
                DateIs
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@Ref, FORMAT(@Ref, N'n0'), @TextIs, @DateIs);

            SET @ID =
            (
                SELECT TOP (1) ID FROM @IDs ORDER BY ID
            );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Alls.t_NotificationMoving
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
            (@UserID, @ID, @Event + N': ' + FORMAT(@Ref, N'n0'), 0, @ComputerIP, @Computer, @ComputerAccount);

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
