SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_EmployeeExecuteJobAgeIs]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Check i need execute

      IF NOT EXISTS ( SELECT TOP ( 1 )
                              s.ID
                      FROM    Alls.t_LastExecuteJob AS s
                      WHERE   s.Employees_Employee_AgeIs < CONVERT(DATE, GETDATE()) )
      BEGIN

        COMMIT TRANSACTION;

        RETURN 1;

      END;

    END;

    DISABLE TRIGGER Employees.tr_Employee ON Employees.t_Employee;

    BEGIN --Update 

      UPDATE  Employees.t_Employee
      SET     AgeIs = DateTimes.f_GetAge(Birthday);

      UPDATE  Employees.t_Employee
      SET     SearchText = Employees.f_EmployeeSearchTextGet(ID);

    END;

    ENABLE TRIGGER Employees.tr_Employee ON Employees.t_Employee;

    BEGIN --Execute is done

      UPDATE  Alls.t_LastExecuteJob
      SET     Employees_Employee_AgeIs = GETDATE();

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
