SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_BankInsertDefaultData]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Check

      IF EXISTS ( SELECT TOP ( 1 )
                          ID
                  FROM    Company.t_Bank )
      BEGIN
			
        COMMIT TRAN;

        RETURN 1;

      END;

    END;

    BEGIN --Insert
		
      INSERT  INTO Company.t_Bank
              DEFAULT VALUES;
		   
      UPDATE  Company.t_Bank
      SET     SearchText = Company.f_BankSearchTextGet(ID);

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
