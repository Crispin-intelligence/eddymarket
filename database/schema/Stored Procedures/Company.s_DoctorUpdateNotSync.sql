SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [Company].[s_DoctorUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Company.tr_Doctor ON Company.t_Doctor;

    BEGIN --Update

      UPDATE Company.t_Doctor
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_Doctor.ID );

    END;

    ENABLE TRIGGER Company.tr_Doctor ON Company.t_Doctor;
   
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Doctor, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
