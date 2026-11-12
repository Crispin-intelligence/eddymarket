CREATE TABLE [Items].[t_Item]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Item_ID] DEFAULT (newsequentialid()),
[ID1] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Item_ID1] DEFAULT (newsequentialid()),
[SharedID] [uniqueidentifier] NOT NULL,
[WareHouseID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Item_WareHouseID] DEFAULT ([Company].[f_WareHouseGetFirstID]()),
[WareHouse] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Item_WareHouse] DEFAULT ([Company].[f_WareHouseGetFirstName]()),
[PlaceID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Item_PlaceID] DEFAULT ([Company].[f_PlaceGetFirstID]()),
[Place] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Item_Place] DEFAULT ([Company].[f_PlaceGetFirstName]()),
[QtyCurrent] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_Items_QtyCurrent] DEFAULT ((0.0)),
[QtyCurrentByUnit] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Item_QtyCurrentByUnit] DEFAULT (''),
[QtyToReorder] [int] NOT NULL CONSTRAINT [DF_t_Item_QtyToReorder] DEFAULT ((0)),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Item_TypeIs] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Item_DescriptionIs] DEFAULT (''),
[LastStockTakeDate] [date] NOT NULL CONSTRAINT [DF_t_Item_LastStockTakeDate] DEFAULT (getdate()),
[StockTakeEvery] [int] NOT NULL CONSTRAINT [DF_t_Item_StockTakeEvery] DEFAULT ((0)),
[StockTakeEveryType] [tinyint] NOT NULL CONSTRAINT [DF_t_Item_StockTakeEveryType] DEFAULT ((2)),
[StockTakeEveryARF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Item_StockTakeEveryARF] DEFAULT ('0 أيام'),
[StockTakeEveryENF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Item_StockTakeEveryENF] DEFAULT ('0 Days'),
[StockTakeEveryNotificationDate] [date] NOT NULL CONSTRAINT [DF_t_Item_StockTakeEveryNotificationDate] DEFAULT (getdate()),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Item_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Item_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Item_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Items_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_Item] ON [Items].[t_Item]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_Item
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Item.ID );

  END;
    
  IF UPDATE(QtyCurrent) --Update QtyCurrent
  BEGIN

    UPDATE  Items.t_Item
    SET     QtyCurrentByUnit = Alls.f_FixXML(( SELECT DISTINCT
                                                      ', ' + FORMAT(t_Item.QtyCurrent / t.Qty, '#,##0.##') + N' ' + t1.Name AS [text()]
                                               FROM   Items.t_UnityItem AS t
                                               LEFT JOIN Items.t_Unity AS t1 ON t1.ID = t.UnityID
                                               WHERE  t.SharedID = t_Item.SharedID
                                                      AND t.Qty > 1
                                             FOR
                                               XML PATH('')
                                             ))
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            t.ID
                     FROM   Inserted AS t
                     WHERE  t.ID = t_Item.ID );

  END;

  IF UPDATE(LastStockTakeDate)
    OR UPDATE(StockTakeEvery) --Update StockTakeEvery
  BEGIN

    UPDATE  Items.t_Item
    SET     StockTakeEveryARF = FORMAT(StockTakeEvery, '0') + CASE StockTakeEveryType
                                                                WHEN 2 THEN N' أيام'
                                                                WHEN 1 THEN N' شهور'
                                                                ELSE N' سنوات'
                                                              END ,
            StockTakeEveryENF = FORMAT(StockTakeEvery, '0') + CASE StockTakeEveryType
                                                                WHEN 2 THEN N' Days'
                                                                WHEN 1 THEN N' Months'
                                                                ELSE N' Years'
                                                              END ,
            StockTakeEveryNotificationDate = CASE StockTakeEveryType
                                               WHEN 2 THEN DATEADD(DAY, StockTakeEvery, LastStockTakeDate)
                                               WHEN 1 THEN DATEADD(MONTH, StockTakeEvery, LastStockTakeDate)
                                               ELSE DATEADD(YEAR, StockTakeEvery, LastStockTakeDate)
                                             END
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            t.ID
                     FROM   Inserted AS t
                     WHERE  t.ID = t_Item.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'item'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'item'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Items].[t_Item] ADD CONSTRAINT [PK_t_Item] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_Item] ADD CONSTRAINT [ItemSharedKeyItem] FOREIGN KEY ([SharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Items].[t_Item] ADD CONSTRAINT [PlaceKeyItem] FOREIGN KEY ([PlaceID]) REFERENCES [Company].[t_Place] ([ID])
GO
ALTER TABLE [Items].[t_Item] ADD CONSTRAINT [WareHouseKeyItem] FOREIGN KEY ([WareHouseID]) REFERENCES [Company].[t_WareHouse] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Year = 0
Month = 1
Day = 2', 'SCHEMA', N'Items', 'TABLE', N't_Item', 'COLUMN', N'StockTakeEveryType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inventory = 0
Services = 1', 'SCHEMA', N'Items', 'TABLE', N't_Item', 'COLUMN', N'TypeIs'
GO
