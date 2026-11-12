SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_SoldDetailProfitPartnerUpdateIsSync] @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Invoices.tr_SoldDetailProfitPartner ON Invoices.t_SoldDetailProfitPartner;

        BEGIN --Insert

            UPDATE Invoices.t_SoldDetailProfitPartner
            SET IsSync = 1
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Invoices.tr_SoldDetailProfitPartner ON Invoices.t_SoldDetailProfitPartner;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;




GO
