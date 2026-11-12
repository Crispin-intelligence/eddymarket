SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Transactions].[s_TransactionDelete]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @EventType TINYINT,
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Fix data

            UPDATE Company.t_Account
            SET StatusIs = 0,
                LastAction = GETDATE()
            WHERE EXISTS
            (
                SELECT TOP (1)
                       s.ID
                FROM Transactions.t_TransactionDetail AS s
                WHERE s.AccountID = t_Account.ID
            )
                  AND StatusIs = 1;

        END;

        BEGIN --Check

            IF NOT EXISTS
            (
                SELECT TOP (1)
                       s.ID
                FROM Transactions.t_Transaction AS s
                WHERE s.ID = @ID
                      AND s.LinkType = 69
            )
            BEGIN

                RETURN 0;

            END;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE FROM Transactions.t_Transaction
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Transactions.t_TransactionMoving
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
            (@UserID, @ID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount);

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
