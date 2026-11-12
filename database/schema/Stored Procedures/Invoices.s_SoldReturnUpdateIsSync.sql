SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Invoices].[s_SoldReturnUpdateIsSync]
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

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Invoices.tr_SoldReturn ON Invoices.t_SoldReturn;

        BEGIN --Insert

            UPDATE Invoices.t_SoldReturn
            SET IsSync = 1
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Invoices.tr_SoldReturn ON Invoices.t_SoldReturn;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Invoices.t_SoldReturnMoving
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
            (@UserID, @ID, @Event, 7, @ComputerIP, @Computer, @ComputerAccount);

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
