SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedBarCodeUpdateIsSync]
    @IsSync BIT,
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Items.tr_ItemSharedBarCode ON Items.t_ItemSharedBarCode;

        BEGIN --Insert

            UPDATE Items.t_ItemSharedBarCode
            SET IsSync = @IsSync
            WHERE ID = @ID;

        END;

		ENABLE TRIGGER Items.tr_ItemSharedBarCode ON Items.t_ItemSharedBarCode;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;










GO
