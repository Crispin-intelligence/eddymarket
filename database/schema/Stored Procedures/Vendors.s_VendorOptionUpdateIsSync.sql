SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Vendors].[s_VendorOptionUpdateIsSync]
    @IsSync BIT,
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Vendors.tr_VendorOption ON Vendors.t_VendorOption;

        BEGIN --Insert

            UPDATE Vendors.t_VendorOption
            SET IsSync = @IsSync
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Vendors.tr_VendorOption ON Vendors.t_VendorOption;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;



GO
