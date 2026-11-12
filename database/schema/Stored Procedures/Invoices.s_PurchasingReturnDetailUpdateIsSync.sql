SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_PurchasingReturnDetailUpdateIsSync]
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Invoices.tr_PurchasingReturnDetail ON Invoices.t_PurchasingReturnDetail;

        BEGIN --Insert

            UPDATE Invoices.t_PurchasingReturnDetail
            SET IsSync = 1
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Invoices.tr_PurchasingReturnDetail ON Invoices.t_PurchasingReturnDetail;
		
        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;








GO
