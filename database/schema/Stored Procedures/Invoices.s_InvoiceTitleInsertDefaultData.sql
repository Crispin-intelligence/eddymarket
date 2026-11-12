SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_InvoiceTitleInsertDefaultData]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Check

      IF EXISTS ( SELECT TOP ( 1 )
                          ID
                  FROM    Invoices.t_InvoiceTitle )
      BEGIN
			
        COMMIT TRAN;

        RETURN 1;

      END;

    END;

    BEGIN --Insert

      INSERT  Invoices.t_InvoiceTitle
              DEFAULT VALUES;

      UPDATE  Invoices.t_InvoiceTitle
      SET     SearchText = Invoices.f_InvoiceTitleSearchTextGet(ID);

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
