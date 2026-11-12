SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemSharedUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;
    DISABLE TRIGGER Items.tr_Item ON Items.t_Item;
    DISABLE TRIGGER Company.tr_AccountItemPrice ON Company.t_AccountItemPrice;
    DISABLE TRIGGER Items.tr_ItemSharedBarCode ON Items.t_ItemSharedBarCode;
    DISABLE TRIGGER Items.tr_ItemSharedVendor ON Items.t_ItemSharedVendor;
    DISABLE TRIGGER Items.tr_UnityItem ON Items.t_UnityItem;
    DISABLE TRIGGER Items.tr_ItemSharedOption ON Items.t_ItemSharedOption;

    BEGIN --Update

      UPDATE Items.t_ItemShared
        SET IsSync = 0;

      UPDATE Items.t_Item
        SET IsSync = 0;

      UPDATE Company.t_AccountItemPrice
        SET IsSync = 0;

      UPDATE Items.t_ItemSharedBarCode
        SET IsSync = 0;

      UPDATE Items.t_ItemSharedVendor
        SET IsSync = 0;

      UPDATE Items.t_UnityItem
        SET IsSync = 0;

      UPDATE Items.t_ItemSharedOption
        SET IsSync = 0;

    END;

    ENABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;
    ENABLE TRIGGER Items.tr_Item ON Items.t_Item;
    ENABLE TRIGGER Company.tr_AccountItemPrice ON Company.t_AccountItemPrice;
    ENABLE TRIGGER Items.tr_ItemSharedBarCode ON Items.t_ItemSharedBarCode;
    ENABLE TRIGGER Items.tr_ItemSharedVendor ON Items.t_ItemSharedVendor;
    ENABLE TRIGGER Items.tr_UnityItem ON Items.t_UnityItem;
    ENABLE TRIGGER Items.tr_ItemSharedOption ON Items.t_ItemSharedOption;

    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
