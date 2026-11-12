CREATE TABLE [Items].[t_StockTakeDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_ID] DEFAULT (newsequentialid()),
[StockTakeID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[QtyCurrent] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_StockTakeDetail_QtyCurrent] DEFAULT ((0)),
[QtyOnHand] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_StockTakeDetail_QtyOnHand] DEFAULT ((0)),
[Qty] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_StockTakeDetail_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTakeDetail_QtyWithUnity] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_StockTakeDetail_Qtys] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTakeDetail_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_PriceEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTakeDetail_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_TotalEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTakeDetail_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_StockTakeDetail_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Items].[t_StockTakeDetail] ADD CONSTRAINT [PK_t_StockTakeDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_StockTakeDetail] ADD CONSTRAINT [ItemKeyStockTakeDetail] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Items].[t_StockTakeDetail] ADD CONSTRAINT [ItemSharedKeyStockTakeDetail] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Items].[t_StockTakeDetail] ADD CONSTRAINT [StockTakeKeyStockTakeDetail] FOREIGN KEY ([StockTakeID]) REFERENCES [Items].[t_StockTake] ([ID])
GO
ALTER TABLE [Items].[t_StockTakeDetail] ADD CONSTRAINT [UnityItemKeyStockTakeDetail] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
