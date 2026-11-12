SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Quotations].[s_QuotationWarrantyInsertDefaultData]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check

            IF EXISTS (SELECT TOP (1) ID FROM Quotations.t_QuotationWarranty)
            BEGIN
			
                COMMIT TRAN;

                RETURN 1;

            END;

        END;

        BEGIN --Insert

            INSERT Quotations.t_QuotationWarranty DEFAULT VALUES;

        END;

        COMMIT TRAN;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN 0;

    END CATCH;

END;





GO
