SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_SoldReturnMovingInserts]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @IDs Alls.tt_Guid READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

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
            SELECT @UserID,
                   s.ID,
                   @Event,
                   3,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @IDs AS s;

        END;

        BEGIN --Live

            UPDATE Alls.t_LiveVersion
            SET VersionLive = STUFF(VersionLive, ReturnSold, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
                SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
