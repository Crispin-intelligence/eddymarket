SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_WareHouseInsert]
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
  @PlaceList NVARCHAR(MAX) ,
  @UserIDs NVARCHAR(MAX) ,
  @EventBase NVARCHAR(MAX) ,
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

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @Place TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          Name NVARCHAR(MAX) NOT NULL ,
          DateCreate DATETIME NOT NULL
        );

      DECLARE @PlaceIDFirst UNIQUEIDENTIFIER ,
        @Return INT;

    END;

    BEGIN --Insert warehouse

      SET @Return = 0;

      INSERT  INTO Company.t_WareHouse
              ( ID ,
                Name ,
                UserID ,
                StatesID ,
                RegionID ,
                StreetID ,
                BuildingID ,
                FloorID ,
                PostalCodeID ,
                AddressNote ,
                DescriptionIs
              )
      VALUES  ( @ID ,
                @Name ,
                @UserID ,
                @StatesID ,
                @RegionID ,
                @StreetID ,
                @BuildingID ,
                @FloorID ,
                @PostalCodeID ,
                @AddressNote ,
                @DescriptionIs
              );

    END;

    BEGIN --Insert phones

      SET @Return = -2;

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

    BEGIN --Insert social media

      SET @Return = -4;

      INSERT  INTO Company.t_SocialMedia
              ( OwnerID ,
                AccountIs ,
                SectionID ,
                TypeID
              )
      SELECT  @ID ,
              RTRIM(LTRIM(t.AccountIs)) ,
              42 ,
              t.TypeID
      FROM    @SocialMedia AS t;

    END;

    BEGIN --Insert places

      SET @PlaceList = [Alls].[f_GetOneAtLess](@PlaceList);

      INSERT  INTO Company.t_Place
              ( Name ,
                WareHouseID ,
                WareHouse
              )
      OUTPUT  Inserted.ID ,
              Inserted.Name ,
              Inserted.DateCreate
              INTO @Place ( ID, Name, DateCreate )
      SELECT DISTINCT
              RTRIM(LTRIM(s.Name)) ,
              @ID ,
              @Name
      FROM    Alls.CastArrayToListString(@PlaceList) AS s;

      SET @PlaceIDFirst = ( SELECT TOP ( 1 )
                                    ID
                            FROM    @Place
                            ORDER BY DateCreate
                          );

    END;

    BEGIN --Insert users

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

    BEGIN --Insert all items in new warehouse

      INSERT  INTO Items.t_Item
              ( SharedID ,
                WareHouseID ,
                WareHouse ,
                PlaceID ,
                QtyToReorder
              )
      SELECT  t.ID ,
              @ID ,
              @Name ,
              @PlaceIDFirst ,
              QtyToReorder
      FROM    Items.t_ItemShared AS t;

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

    BEGIN --Insert event Place

      INSERT  INTO Company.t_PlaceMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      SELECT  @UserID ,
              s.ID ,
              @EventBase + s.Name ,
              @EventType ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @Place AS s;

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
