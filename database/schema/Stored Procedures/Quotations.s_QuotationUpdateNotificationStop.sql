SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Quotations].[s_QuotationUpdateNotificationStop]
    @NotificationStop BIT,
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

            DECLARE @return INT;

        END;

        BEGIN --Update

            SET @return = 0;

            UPDATE Quotations.t_Quotation
            SET NotificationStop = @NotificationStop
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @return = -1;

            INSERT INTO Quotations.t_QuotationMoving
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
            (@UserID, @ID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

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
