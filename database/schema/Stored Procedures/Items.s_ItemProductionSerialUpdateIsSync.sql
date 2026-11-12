SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemProductionSerialUpdateIsSync] @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Items.tr_ItemProductionSerial ON Invoices.t_ItemProductionSerial;

        BEGIN --Insert

            UPDATE Items.t_ItemProductionSerial
            SET IsSync = 1
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Items.tr_ItemProductionSerial ON Invoices.t_ItemProductionSerial;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;




GO
