SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountUserBlockedInsert]
    @AccountID UNIQUEIDENTIFIER,
    @UserAssignID UNIQUEIDENTIFIER,
    @CanUse BIT,
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

        BEGIN --DECLARE

            DECLARE @IDs TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL
            );

            DECLARE @Return INT;

        END;

        BEGIN --Insert Account

            SET @Return = 0;

            INSERT INTO Company.t_AccountUserBlocked
            (
                AccountID,
                Account,
                UserID,
                UserIs,
                CanUse
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@AccountID, Company.f_AccountGetName(@AccountID), @UserAssignID, Users.f_UserGetName(@UserAssignID),
             @CanUse);

            SET @ID =
            (
                SELECT TOP (1) ID FROM @IDs ORDER BY ID
            );

        END;

        BEGIN --Rebuilding statistics Account

            UPDATE Company.t_Account
            SET UserBlockedC =
                (
                    SELECT COUNT(*)
                    FROM Company.t_AccountUserBlocked AS s
                    WHERE s.AccountID = t_Account.ID
                ),
                UsersNames = Alls.f_FixXML(
                             (
                                 SELECT ', ' + t1.Name AS [text()]
                                 FROM Company.t_AccountUserBlocked AS t
                                     LEFT JOIN Users.t_User AS t1
                                         ON t1.ID = t.UserID
                                 WHERE t.AccountID = t_Account.ID
                                 FOR XML PATH('')
                             )
                                          )
            WHERE ID = @AccountID;

        END;

        BEGIN --Rebuilding statistics User

            UPDATE Users.t_User
            SET AccountBlockedC =
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
                                            )
            WHERE ID = @UserAssignID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_AccountMoving
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
            (@UserID, @AccountID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

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
