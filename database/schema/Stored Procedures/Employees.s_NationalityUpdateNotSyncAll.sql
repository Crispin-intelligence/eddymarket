SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Employees].[s_NationalityUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Employees.tr_Nationality ON Employees.t_Nationality;

    BEGIN --Update

      UPDATE Employees.t_Nationality
        SET IsSync = 0;

    END;

    ENABLE TRIGGER Employees.tr_Nationality ON Employees.t_Nationality;
  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Nationality, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN 0;

  END CATCH;

END;





GO
