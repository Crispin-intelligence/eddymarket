SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemProductionMaterialUpdateIsSync] @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Items.tr_ItemProductionMaterial ON Invoices.t_ItemProductionMaterial;

        BEGIN --Insert

            UPDATE Items.t_ItemProductionMaterial
            SET IsSync = 1
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Items.tr_ItemProductionMaterial ON Invoices.t_ItemProductionMaterial;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;




GO
