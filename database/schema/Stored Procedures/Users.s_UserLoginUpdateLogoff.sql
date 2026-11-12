SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Users].[s_UserLoginUpdateLogoff]
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
                    @OnlineCount BIGINT;

        END;

        BEGIN --Update

            UPDATE Users.t_UserLogin
            SET EndTime = GETDATE(),
                WorkTime = DateTimes.f_DateTimeDiff(StartTime, GETDATE(), N'd', 1, '', ''),
                HoursIs = (DATEDIFF(SECOND, StartTime, GETDATE()) / 60.0) / 60.0,
                IsOnline = 0
            WHERE ID = @ID;

        END;

        BEGIN -- Update online

            SELECT @OnlineCount = COUNT(*)
            FROM Users.t_UserLogin AS t
            WHERE t.IsOnline = 1
                  AND t.UserID = @UserID;

            UPDATE Users.t_User
            SET IsOnline = IIF(@OnlineCount > 0, 1, 0)
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
