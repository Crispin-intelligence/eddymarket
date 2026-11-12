SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_WareHouseUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Update

      UPDATE  Company.t_WareHouse
      SET     IsSync = 0;

      UPDATE  Company.t_WarehouseUser
      SET     IsSync = 0;

      UPDATE  Company.t_BookPhone
      SET     IsSync = 0
	  WHERE SectionID = 42;

      UPDATE  Company.t_SocialMedia
      SET     IsSync = 0
	  WHERE SectionID = 42;

    END;
  
    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, Warehouse, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
