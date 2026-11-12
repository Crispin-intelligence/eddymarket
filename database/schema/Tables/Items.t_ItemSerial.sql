CREATE TABLE [Items].[t_ItemSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSerial_ID] DEFAULT (newsequentialid()),
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[SerialText] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSerial_SerialText] DEFAULT (''),
[IsAvailable] [tinyint] NOT NULL CONSTRAINT [DF_t_ItemSerial_IsAvailable] DEFAULT ((1)),
[SectionType] [int] NOT NULL CONSTRAINT [DF_t_ItemSerial_SectionType] DEFAULT ((69)),
[LinkID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSerial_LinkID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[LastSectionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSerial_LastSectionID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ItemSerial_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemSerial] ADD CONSTRAINT [PK_t_ItemSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemSerial] ADD CONSTRAINT [ItemKeyItemSerial] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Items].[t_ItemSerial] ADD CONSTRAINT [ItemSharedKeyItemSerial] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'no = 0
yes = 1
underTransfer = 2
reservedDeliveryPermission = 3', 'SCHEMA', N'Items', 'TABLE', N't_ItemSerial', 'COLUMN', N'IsAvailable'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchase = 0
StockAdjustment = 7
None = 69
StockTake = 101
ItemProduction = 155
BeginningInventoryQuantity = 158', 'SCHEMA', N'Items', 'TABLE', N't_ItemSerial', 'COLUMN', N'SectionType'
GO
