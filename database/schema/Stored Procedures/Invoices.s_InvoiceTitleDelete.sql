SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Invoices].[s_InvoiceTitleDelete]
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

        BEGIN --Delete

            SET @Return = 0;

            DELETE FROM Invoices.t_InvoiceTitle
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Invoices.t_InvoiceTitleMoving
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
