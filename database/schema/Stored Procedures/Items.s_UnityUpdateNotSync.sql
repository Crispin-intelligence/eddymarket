SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Items].[s_UnityUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Items.tr_Unity ON Items.t_Unity;

    BEGIN --Update

      UPDATE Items.t_Unity
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_Unity.ID );

    END;

    ENABLE TRIGGER Items.tr_Unity ON Items.t_Unity;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Unity, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
