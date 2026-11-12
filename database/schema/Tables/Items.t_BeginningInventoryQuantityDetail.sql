CREATE TABLE [Items].[t_BeginningInventoryQuantityDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_ID] DEFAULT (newsequentialid()),
[BeginningInventoryQuantityID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_QtyWithUnity] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_Qtys] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_PriceEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_TotalEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetail_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Items].[t_BeginningInventoryQuantityDetail] ADD CONSTRAINT [PK_t_BeginningInventoryQuantityDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_BeginningInventoryQuantityDetail] ADD CONSTRAINT [BeginningInventoryQuantityKeyBeginningInventoryQuantityDetail] FOREIGN KEY ([BeginningInventoryQuantityID]) REFERENCES [Items].[t_BeginningInventoryQuantity] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [Items].[t_BeginningInventoryQuantityDetail] ADD CONSTRAINT [ItemKeyBeginningInventoryQuantityDetail] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Items].[t_BeginningInventoryQuantityDetail] ADD CONSTRAINT [ItemSharedKeyBeginningInventoryQuantityDetail] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Items].[t_BeginningInventoryQuantityDetail] ADD CONSTRAINT [UnityItemKeyBeginningInventoryQuantityDetail] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
