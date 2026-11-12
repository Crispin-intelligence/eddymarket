SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [Quotations].[s_QuotationUpdateIsConfirm]
    @IsConfirm bit,
    @UserID UNIQUEIDENTIFIER,
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @IDAndEvent Alls.tt_IDAndEvent READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Update 

            SET @Return = 0;

            UPDATE Quotations.t_Quotation
            SET IsConfirm = @IsConfirm
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDAndEvent AS s WHERE s.ID = t_Quotation.ID
            );

        END;

        BEGIN --Insert event

            SET @Return = -1;

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
            SELECT @UserID,
                   s.ID,
                   s.EventIs,
                   1,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @IDAndEvent AS s;

        END;

        COMMIT TRANSACTION;

        SELECT 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT @Return;

    END CATCH;

END;









GO
