SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_DoctorExecuteJobAgeIs]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Check i need execute

      IF NOT EXISTS ( SELECT TOP ( 1 )
                              s.ID
                      FROM    Alls.t_LastExecuteJob AS s
                      WHERE   s.Company_Doctor_AgeIs < CONVERT(DATE, GETDATE()) )
      BEGIN

        COMMIT TRANSACTION;

        RETURN 1;

      END;

    END;

    BEGIN --Update 

      UPDATE  Company.t_Doctor
      SET     AgeIs = DateTimes.f_GetAge(Birthday) ,
              IsSync = 0;

      UPDATE  Company.t_Doctor
      SET     SearchText = Company.f_DoctorSearchTextGet(ID);

    END;

    BEGIN --Execute is done

      UPDATE  Alls.t_LastExecuteJob
      SET     Company_Doctor_AgeIs = GETDATE();

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
