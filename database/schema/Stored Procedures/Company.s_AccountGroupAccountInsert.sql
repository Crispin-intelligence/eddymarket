SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountGroupAccountInsert]
    @AccountGroupID UNIQUEIDENTIFIER,
    @AccountID UNIQUEIDENTIFIER,
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

            INSERT INTO Company.t_AccountGroupAccount
            (
                AccountGroupID,
                AccountGroup,
                AccountID,
                Account
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@AccountGroupID, Company.f_AccountGroupGetName(@AccountGroupID), @AccountID,
             Company.f_AccountGetName(@AccountID));

            SET @ID =
            (
                SELECT TOP (1) ID FROM @IDs ORDER BY ID
            );

        END;

        BEGIN --Rebuilding statistics t_AccountGroup

            UPDATE Company.t_AccountGroup
            SET AccountC =
                (
                    SELECT COUNT(*)
                    FROM Company.t_AccountGroupAccount AS s
                    WHERE s.AccountGroupID = t_AccountGroup.ID
                ),
                AccountNames = Alls.f_FixXML(
                               (
                                   SELECT ', ' + t.Account AS [text()]
                                   FROM Company.t_AccountGroupAccount AS t
                                   WHERE t.AccountGroupID = t_AccountGroup.ID
                                   FOR XML PATH('')
                               )
                                            )
            WHERE ID = @AccountGroupID;

        END;


        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_AccountGroupMoving
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
            (@UserID, @AccountGroupID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

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
