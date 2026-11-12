SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedDelete]
  @UserID UNIQUEIDENTIFIER ,
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

    BEGIN --Declare

      DECLARE @MainCategoryID UNIQUEIDENTIFIER ,
        @Return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @MainCategoryID = s.MainCategoryID
      FROM    Items.t_ItemShared AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    DISABLE TRIGGER Items.tr_Item ON Items.t_Item;

    DISABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;

    BEGIN --Delete t_ItemSharedBarCode

      SET @Return = 0;

      DELETE  FROM Items.t_ItemSharedBarCode
      WHERE   SharedID = @ID;

    END;

    BEGIN --Delete t_ItemSharedVendor

      DELETE  FROM Items.t_ItemSharedVendor
      WHERE   SharedID = @ID;

    END;

    BEGIN --Delete t_AccountItemPrice

      DELETE  FROM Company.t_AccountItemPrice
      WHERE   ItemSharedID = @ID;

    END;

    BEGIN --Delete t_UnityItem

      DELETE  FROM Items.t_UnityItem
      WHERE   SharedID = @ID;

    END;

    BEGIN --For delete

      INSERT  INTO Alls.t_FireStoreRowsForDelete
              ( DocumentID ,
                HasImage ,
                TableName
              )
      SELECT  @ID ,
              1 ,
              'itemShared'
      UNION ALL
      SELECT  s.ID ,
              0 ,
              'item'
      FROM    Items.t_Item AS s
      WHERE   s.SharedID = @ID;

    END;

    BEGIN --Delete t_Item

      DELETE  FROM Items.t_Item
      WHERE   SharedID = @ID;

    END;

    BEGIN --Delete File Storage Linked 

      DELETE  FROM Company.t_FileStorageLinked
      WHERE   SectionID = 10
              AND OwnerID = @ID;

    END;

    BEGIN --Delete t_ItemSharedMaterial 

      DELETE  FROM Items.t_ItemSharedMaterial
      WHERE   ItemSharedFatherID = @ID;

    END;

    BEGIN --Delete

      DELETE  FROM Items.t_ItemShared
      WHERE   ID = @ID;

    END;

    BEGIN --Rebuilding statistics t_MainCategory

      UPDATE  Items.t_MainCategory
      SET     ItemC -= 1 ,
              ItemInListCount = ( SELECT  COUNT(*) AS Total
                                  FROM    Items.t_ItemShared AS t
                                  WHERE   t.MainCategoryID = t_MainCategory.ID
                                          AND t.InList = 1
                                )
      WHERE   ID = @MainCategoryID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_ItemSharedMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @ID ,
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    ENABLE TRIGGER Items.tr_Item ON Items.t_Item;

    ENABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    ENABLE TRIGGER Items.tr_Item ON Items.t_Item;

    ENABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;

    RETURN @Return;

  END CATCH;

END;








GO
