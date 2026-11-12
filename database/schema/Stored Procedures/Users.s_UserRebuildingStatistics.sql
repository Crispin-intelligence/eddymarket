SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Users].[s_UserRebuildingStatistics]
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

        DISABLE TRIGGER Users.tr_UserLoginHistory ON Users.t_UserLoginHistory;

        BEGIN --Move offline

            SET @Return = 0;

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

        END;

        BEGIN --Rebuild statistics

            UPDATE Users.t_User
            SET PermissionIs = Users.f_PermissionGetName(PermissionID),
                BeginWorkF = FORMAT(CAST(BeginWork AS DATETIME), 'hh:mm tt', 'ar-lb'),
                EndWorkF = FORMAT(CAST(EndWork AS DATETIME), 'hh:mm tt', 'ar-lb'),
                HoursIs =
                (
                    SELECT ISNULL(SUM(s.HoursIs), 0)
                    FROM Users.t_UserLoginHistory AS s
                    WHERE s.UserID = t_User.ID
                ),
                LoginC =
                (
                    SELECT COUNT_BIG(s.ID)
                    FROM Users.t_UserLoginHistory AS s
                    WHERE s.UserID = t_User.ID
                ),
                AccountBlockedC =
                (
                    SELECT COUNT(*)
                    FROM Company.t_AccountUserBlocked AS s
                    WHERE s.UserID = t_User.ID
                ),
                AccountNames = Alls.f_FixXML(
                               (
                                   SELECT ', ' + t1.Name AS [text()]
                                   FROM Company.t_AccountUserBlocked AS t
                                       LEFT JOIN Company.t_Account AS t1
                                           ON t1.ID = t.AccountID
                                   WHERE t.UserID = t_User.ID
                                   FOR XML PATH('')
                               )
                                            ),
                IsSync = 0;

            UPDATE Users.t_User
            SET WorkTime = DateTimes.f_DateTimeDiff(GETDATE(), GETDATE() + (HoursIs / 24), N'y', 1, '', '');

            UPDATE Users.t_UserLogin
            SET UserIs = Users.f_UserGetName(UserID),
                WorkTime = DateTimes.f_DateTimeDiff(StartTime, EndTime, N'd', 1, '', ''),
                HoursIs = (DATEDIFF(SECOND, StartTime, EndTime) / 60.0) / 60.0;

        END;

        BEGIN --Rebuilding statistics User Blocked

            UPDATE Company.t_AccountUserBlocked
            SET UserIs = Users.f_UserGetName(UserID);

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
            (@UserID, '00000000-0000-0000-0000-000000000000', @Event, 6, @ComputerIP, @Computer, @ComputerAccount);

        END;

        COMMIT TRANSACTION;

        ENABLE TRIGGER Users.tr_UserLoginHistory ON Users.t_UserLoginHistory;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        ENABLE TRIGGER Users.tr_UserLoginHistory ON Users.t_UserLoginHistory;

        RETURN @Return;

    END CATCH;

END;




GO
