SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountGroupRangeUpdate]
    @FromNumber BIGINT,
    @ToNumber BIGINT,
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

            DECLARE @Return INT,
                    @AccountGroupID UNIQUEIDENTIFIER;

        END;

        BEGIN --Set info

            SELECT TOP (1)
                   @AccountGroupID = s.AccountGroupID
            FROM Company.t_AccountGroupRange AS s
            WHERE s.ID = @ID
            ORDER BY s.ID;

        END;

        BEGIN --Insert Account

            SET @Return = 0;

            UPDATE Company.t_AccountGroupRange
            SET FromNumber = @FromNumber,
                ToNumber = @ToNumber
            WHERE ID = @ID;

        END;

        BEGIN --Rebuilding statistics t_AccountGroup

            UPDATE Company.t_AccountGroup
            SET RangeNames = Alls.f_FixXML(
                             (
                                 SELECT ', ' + FORMAT(t.FromNumber, '00,0,00,00000') + ' => '
                                        + FORMAT(t.ToNumber, '00,0,00,00000') AS [text()]
                                 FROM Company.t_AccountGroupRange AS t
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
