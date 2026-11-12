SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Alls].[s_CompanyInfoInsertDefaultData]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Check

      IF EXISTS ( SELECT TOP ( 1 )
                          ID
                  FROM    Alls.t_CompanyInfo )
      BEGIN

        COMMIT TRAN;

        RETURN 1;

      END;

    END;

    BEGIN --Insert

      INSERT  [Alls].t_CompanyInfo
              DEFAULT VALUES;

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
