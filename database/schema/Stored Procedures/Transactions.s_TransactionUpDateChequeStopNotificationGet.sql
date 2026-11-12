SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Transactions].[s_TransactionUpDateChequeStopNotificationGet]
    @ChequeStopNotificationGet BIT,
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

            DECLARE @return INT,
                    @TransactionID UNIQUEIDENTIFIER;

        END;

        BEGIN --Declare

            SELECT TOP (1)
                   @TransactionID = s.TransactionID
            FROM Transactions.t_TransactionDetail AS s
            WHERE s.ID = @ID
            ORDER BY s.ID;

        END;

        BEGIN --Update transaction

            SET @return = 0;

            UPDATE Transactions.t_TransactionDetail
            SET ChequeStopNotificationGet = @ChequeStopNotificationGet
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @return = -1;

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
            (@UserID, @TransactionID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

        END;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @return;

    END CATCH;

END;





GO
