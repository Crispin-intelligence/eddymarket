SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountGroupRebuildingStatistics]
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

        BEGIN --t_AccountGroupAccount

            UPDATE Company.t_AccountGroupAccount
            SET AccountGroup = Company.f_AccountGroupGetName(AccountGroupID),
                Account = Company.f_AccountGetName(AccountID);

        END;

        BEGIN --Rebuilding statistics

            SET @Return = 0;

            UPDATE Company.t_AccountGroup
            SET Currency = Currencys.f_CurrencyGetName(CurrencyID),
                AccountC =
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
                                            ),
                RangeC =
                (
                    SELECT COUNT(*)
                    FROM Company.t_AccountGroupRange AS s
                    WHERE s.AccountGroupID = t_AccountGroup.ID
                ),
                RangeNames = Alls.f_FixXML(
                             (
                                 SELECT ', ' + FORMAT(t.FromNumber, '00,0,00,00000') + ' => '
                                        + FORMAT(t.ToNumber, '00,0,00,00000') AS [text()]
                                 FROM Company.t_AccountGroupRange AS t
                                 WHERE t.AccountGroupID = t_AccountGroup.ID
                                 FOR XML PATH('')
                             )
                                          );

        END;

        BEGIN --Account Merge

            UPDATE Company.t_AccountGroupRange
            SET AccountGroup = Company.f_AccountGroupGetName(AccountGroupID);

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
            (@UserID, '00000000-0000-0000-0000-000000000000', @Event, 6, @ComputerIP, @Computer, @ComputerAccount);

        END;

        COMMIT TRAN;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;
END;








GO
