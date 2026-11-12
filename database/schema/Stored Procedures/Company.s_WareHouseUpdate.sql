SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_WareHouseUpdate]
  @Name NVARCHAR(450) ,
  @UserID UNIQUEIDENTIFIER ,
  @Phones Company.td_BookPhone READONLY ,
  @SocialMedia Company.dt_SocialMedia READONLY ,
  @StatesID UNIQUEIDENTIFIER ,
  @RegionID UNIQUEIDENTIFIER ,
  @StreetID UNIQUEIDENTIFIER ,
  @BuildingID UNIQUEIDENTIFIER ,
  @FloorID UNIQUEIDENTIFIER ,
  @PostalCodeID UNIQUEIDENTIFIER ,
  @AddressNote NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @UserIDs NVARCHAR(MAX) ,
  @EventUserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --DECLARE

      DECLARE @Return INT ,
        @NameOld NVARCHAR(450);

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Company.t_WareHouse AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update warehouse

      SET @Return = 0;

      UPDATE  Company.t_WareHouse
      SET     Name = @Name ,
              UserID = @UserID ,
              StatesID = @StatesID ,
              RegionID = @RegionID ,
              StreetID = @StreetID ,
              BuildingID = @BuildingID ,
              FloorID = @FloorID ,
              PostalCodeID = @PostalCodeID ,
              AddressNote = @AddressNote ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

    END;

    BEGIN --Reinsert phones

      SET @Return = -2;

      DELETE  FROM Company.t_BookPhone
      WHERE   OwnerID = @ID
              AND SectionID = 42;

      INSERT  INTO Company.t_BookPhone
              ( OwnerID ,
                NumberIs ,
                SectionID ,
                NumberType ,
                LanguageCodeID ,
                ExtensionIs
              )
      SELECT DISTINCT
              @ID ,
              t.NumberIs ,
              42 ,
              t.TypeIs ,
              t.LanguageCodeID ,
              t.ExtensionIs
      FROM    @Phones AS t;

    END;

    BEGIN --Reinsert social media

      SET @Return = -4;

      DELETE  FROM Company.t_SocialMedia
      WHERE   OwnerID = @ID
              AND SectionID = 42;

      INSERT  INTO Company.t_SocialMedia
              ( OwnerID ,
                AccountIs ,
                SectionID ,
                TypeID
              )
      SELECT DISTINCT
              @ID ,
              t.AccountIs ,
              42 ,
              t.TypeID
      FROM    @SocialMedia AS t;

    END;

    BEGIN --Reinsert users

      DELETE  FROM Company.t_WarehouseUser
      WHERE   WarehouseID = @ID;

      INSERT  INTO Company.t_WarehouseUser
              ( WarehouseID ,
                Warehouse ,
                UserID ,
                UserIs
              )
      SELECT DISTINCT
              @ID ,
              @Name ,
              t.ID ,
              Users.f_UserGetName(t.ID)
      FROM    Alls.[CastArrayToListGuid](@UserIDs) AS t;

    END;

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix Name

      BEGIN --Fix Item

        UPDATE  Items.t_Item
        SET     WareHouse = @Name
        WHERE   WareHouseID = @ID;

      END;

      BEGIN --Fix t_Transfer

        UPDATE  Invoices.t_Transfer
        SET     FromWarehouse = @Name
        WHERE   FromWarehouseID = @ID;

        UPDATE  Invoices.t_Transfer
        SET     ToWarehouse = @Name
        WHERE   ToWarehouseID = @ID;

        UPDATE  Invoices.t_TransferAwaited
        SET     FromWarehouse = @Name
        WHERE   FromWarehouseID = @ID;

        UPDATE  Invoices.t_TransferAwaited
        SET     ToWarehouse = @Name
        WHERE   ToWarehouseID = @ID;

      END;

      BEGIN --Fix t_StockTake

        UPDATE  Items.t_StockTake
        SET     Warehouse = @Name
        WHERE   WarehouseID = @ID;

      END;

      BEGIN --Fix t_ItemExpirationDate

        UPDATE  Items.t_ItemExpirationDate
        SET     WareHouse = @Name
        WHERE   WareHouseID = @ID;

      END;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_WarehouseMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @EventUserID ,
                @ID ,
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    COMMIT TRANSACTION;

    BEGIN --Rebuilding statistics

      EXECUTE [Company].[s_WarehouseRebuildingStatisticsOf] @ID;

    END;

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  @Return;

  END CATCH;

END;








GO
