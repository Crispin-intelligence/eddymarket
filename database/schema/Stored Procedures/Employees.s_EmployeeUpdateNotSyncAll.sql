SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Employees].[s_EmployeeUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Employees.tr_Employee ON Employees.t_Employee;

    BEGIN --Update

      UPDATE Employees.t_Employee
        SET IsSync = 0;

    END;

    ENABLE TRIGGER Employees.tr_Employee ON Employees.t_Employee;
  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Employee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
