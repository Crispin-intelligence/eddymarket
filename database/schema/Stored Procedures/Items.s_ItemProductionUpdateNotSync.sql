SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemProductionUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Items.tr_ItemProduction ON Items.t_ItemProduction;
    DISABLE TRIGGER Items.tr_ItemProductionMaterial ON Items.t_ItemProductionMaterial;
    DISABLE TRIGGER Items.tr_ItemProductionMaterialSerial ON Items.t_ItemProductionMaterialSerial;
    DISABLE TRIGGER Items.tr_ItemProductionSerial ON Items.t_ItemProductionSerial;

    BEGIN --Update

      UPDATE Items.t_ItemProduction
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_ItemProduction.ID );

      UPDATE Items.t_ItemProductionMaterial
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_ItemProductionMaterial.ItemProductionID );

      UPDATE Items.t_ItemProductionMaterialSerial
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_ItemProductionMaterialSerial.ItemProductionID );

      UPDATE Items.t_ItemProductionSerial
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_ItemProductionSerial.ItemProductionID );

    END;

    ENABLE TRIGGER Items.tr_ItemProduction ON Items.t_ItemProduction;
    ENABLE TRIGGER Items.tr_ItemProductionMaterial ON Items.t_ItemProductionMaterial;
    ENABLE TRIGGER Items.tr_ItemProductionMaterialSerial ON Items.t_ItemProductionMaterialSerial;
    ENABLE TRIGGER Items.tr_ItemProductionSerial ON Items.t_ItemProductionSerial;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, ItemProduction, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
