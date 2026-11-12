SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountMergeInsert]
    @AccountID UNIQUEIDENTIFIER,
    @AccountIDWith UNIQUEIDENTIFIER,
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

            INSERT INTO Company.t_AccountMerge
            (
                AccountID,
                Account,
                AccountNumber,
                AccountNumberF,
                AccountIDWith,
                AccountWith,
                AccountWithNumber,
                AccountWithNumberF
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@AccountID, Company.f_AccountGetName(@AccountID), Company.f_AccountGetNumber(@AccountID),
             Company.f_AccountGetNumberF(@AccountID), @AccountIDWith, Company.f_AccountGetName(@AccountIDWith),
             Company.f_AccountGetNumber(@AccountIDWith), Company.f_AccountGetNumberF(@AccountIDWith));

            SET @ID =
            (
                SELECT TOP (1) ID FROM @IDs ORDER BY ID
            );

        END;

        BEGIN --Rebuilding statistics

            UPDATE Company.t_Account
            SET AccountMergeC =
                (
                    SELECT COUNT(*)
                    FROM Company.t_AccountMerge AS s
                    WHERE s.AccountID = t_Account.ID
                ),
                AccountMergeNames = Alls.f_FixXML(
                                    (
                                        SELECT ', ' + t.AccountWith AS [text()]
                                        FROM Company.t_AccountMerge AS t
                                        WHERE t.AccountID = t_Account.ID
                                        FOR XML PATH('')
                                    )
                                                 )
            WHERE ID = @AccountID;

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
