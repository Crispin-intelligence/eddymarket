SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Location].[s_StatesUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Location.tr_States ON Location.t_States;

    BEGIN --Update

      UPDATE Location.t_States
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_States.ID );

    END;

    ENABLE TRIGGER Location.tr_States ON Location.t_States;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, States, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaLocation, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
