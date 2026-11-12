CREATE TABLE [Items].[t_ItemExpirationDate]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_RefF] DEFAULT (''),
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[WareHouseID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_WareHouseID] DEFAULT ([Company].[f_WareHouseGetFirstID]()),
[WareHouse] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_WareHouse] DEFAULT ([Company].[f_WareHouseGetFirstName]()),
[PlaceID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_PlaceID] DEFAULT ([Company].[f_PlaceGetFirstID]()),
[Place] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_Place] DEFAULT ([Company].[f_PlaceGetFirstName]()),
[SectionIs] [int] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_SectionIs] DEFAULT ((10)),
[SectionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_SectionID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[Barcode] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_Barcode] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_Qtys] DEFAULT ((0)),
[ProductionDate] [date] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_ProductionDate] DEFAULT (getdate()),
[ExpirationDate] [date] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_ExpirationDate] DEFAULT (getdate()),
[NotifyMeDaysBefore] [int] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_NotifyMeDaysBefore] DEFAULT ((0)),
[NotificationDate] [date] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_NotificationDate] DEFAULT (getdate()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[Price] [float] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_PriceEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_DescriptionIs] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemExpirationDate_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ItemExpirationDate] ON [Items].[t_ItemExpirationDate]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_ItemExpirationDate
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_ItemExpirationDate.ID );

  END;
 
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'itemExpirationDate'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'itemExpirationDate'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, ItemExpirationDate, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Items].[t_ItemExpirationDate] ADD CONSTRAINT [PK_t_ItemExpirationDate] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_ItemExpirationDate_Ref] ON [Items].[t_ItemExpirationDate] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemExpirationDate] ADD CONSTRAINT [CurrencyKeyItemExpirationDate] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Items].[t_ItemExpirationDate] ADD CONSTRAINT [ItemKeyItemExpirationDate] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Items].[t_ItemExpirationDate] ADD CONSTRAINT [ItemSharedKeyItemExpirationDate] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Items].[t_ItemExpirationDate] ADD CONSTRAINT [PlaceKeyItemExpirationDate] FOREIGN KEY ([PlaceID]) REFERENCES [Company].[t_Place] ([ID])
GO
ALTER TABLE [Items].[t_ItemExpirationDate] ADD CONSTRAINT [WareHouseKeyItemExpirationDate] FOREIGN KEY ([WareHouseID]) REFERENCES [Company].[t_WareHouse] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchase = 0
Item = 10
BeginningInventoryQuantity = 158', 'SCHEMA', N'Items', 'TABLE', N't_ItemExpirationDate', 'COLUMN', N'SectionIs'
GO
