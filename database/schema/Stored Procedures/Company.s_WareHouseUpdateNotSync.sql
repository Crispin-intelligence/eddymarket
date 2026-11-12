SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_WareHouseUpdateNotSync]
  @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Update

      UPDATE  Company.t_WareHouse
      SET     IsSync = 0
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDs AS s
                       WHERE  s.ID = t_WareHouse.ID );

      UPDATE  Company.t_WarehouseUser
      SET     IsSync = 0
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDs AS s
                       WHERE  s.ID = t_WarehouseUser.WarehouseID );

      UPDATE  Company.t_BookPhone
      SET     IsSync = 0
      WHERE   SectionID = 42
              AND EXISTS ( SELECT TOP ( 1 )
                                  s.ID
                           FROM   @IDs AS s
                           WHERE  s.ID = t_BookPhone.OwnerID );

      UPDATE  Company.t_SocialMedia
      SET     IsSync = 0
      WHERE   SectionID = 42
              AND EXISTS ( SELECT TOP ( 1 )
                                  s.ID
                           FROM   @IDs AS s
                           WHERE  s.ID = t_SocialMedia.OwnerID );

    END;
	  
    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, Warehouse, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    COMMIT TRANSACTION;

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  0;

  END CATCH;

END;



GO
