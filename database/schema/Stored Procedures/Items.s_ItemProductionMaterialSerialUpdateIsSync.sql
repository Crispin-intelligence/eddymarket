SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemProductionMaterialSerialUpdateIsSync] @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Items.tr_ItemProductionMaterialSerial ON Invoices.t_ItemProductionMaterialSerial;

        BEGIN --Insert

            UPDATE Items.t_ItemProductionMaterialSerial
            SET IsSync = 1
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Items.tr_ItemProductionMaterialSerial ON Invoices.t_ItemProductionMaterialSerial;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;




GO
