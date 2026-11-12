SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Users].[s_UserLoginInsert]
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

            DECLARE @Return INT;

        END;

        BEGIN --Set offline

            SET @Return = 0;

            UPDATE Users.t_UserLogin
            SET [IsOnline] = 0
            WHERE UserID = @UserID
                  AND ComputerIP = @ComputerIP;

            UPDATE Users.t_UserLogin
            SET IsOnline = 0
            WHERE IsOnline = 1
                  AND DateIs <= GETDATE() - .1;

        END;

        BEGIN --Insert login

            INSERT INTO Users.t_UserLogin
            (
                UserID,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@UserID, @ComputerIP, @Computer, @ComputerAccount);

            SET @ID =
            (
                SELECT TOP (1) ID FROM @IDs ORDER BY ID
            );

        END;

        BEGIN --Set online

            UPDATE Users.t_User
            SET IsOnline = 1
            WHERE ID = @UserID;

        END;

        BEGIN --Move offline

            INSERT INTO Users.t_UserLoginHistory
            (
                ID,
                UserID,
                UserIs,
                DateIs,
                StartTime,
                EndTime,
                WorkTime,
                HoursIs,
                ComputerIP,
                Computer,
                ComputerAccount,
                IsOnline,
                WorkStationID
            )
            SELECT t.ID,
                   t.UserID,
                   t.UserIs,
                   t.DateIs,
                   t.StartTime,
                   t.EndTime,
                   t.WorkTime,
                   t.HoursIs,
                   t.ComputerIP,
                   t.Computer,
                   t.ComputerAccount,
                   t.IsOnline,
                   t.WorkStationID
            FROM Users.t_UserLogin AS t
            WHERE t.IsOnline = 0;

            DELETE FROM Users.t_UserLogin
            WHERE IsOnline = 0;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Users.t_UserMoving
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
            (@UserID, @UserID, @Event, 5, @ComputerIP, @Computer, @ComputerAccount);

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
