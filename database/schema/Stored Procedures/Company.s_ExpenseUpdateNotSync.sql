SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_ExpenseUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Company.tr_Expense ON Company.t_Expense;

    BEGIN --Update

      UPDATE Company.t_Expense
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_Expense.ID );

    END;

    ENABLE TRIGGER Company.tr_Expense ON Company.t_Expense;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Expense, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    COMMIT TRANSACTION;

    SELECT 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT 0;

  END CATCH;

END;



GO
