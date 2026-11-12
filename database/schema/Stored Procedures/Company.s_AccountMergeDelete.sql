SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountMergeDelete]
    @AccountID UNIQUEIDENTIFIER,
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

        BEGIN --DECLARE

            DECLARE @Return INT;

        END;

        BEGIN --Delete Account

            SET @Return = 0;

            DELETE FROM Company.t_AccountMerge
            WHERE ID = @ID;

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
