CREATE TABLE [Items].[t_StockAdjustmentDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_ID] DEFAULT (newsequentialid()),
[StockAdjustmentID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_QtyWithUnity] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_Qtys] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_PriceEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_TotalEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetail_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Items].[t_StockAdjustmentDetail] ADD CONSTRAINT [PK_t_StockAdjustmentDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_StockAdjustmentDetail] ADD CONSTRAINT [ItemKeyStockAdjustmentDetail] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Items].[t_StockAdjustmentDetail] ADD CONSTRAINT [ItemSharedKeyStockAdjustmentDetail] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Items].[t_StockAdjustmentDetail] ADD CONSTRAINT [StockAdjustmentKeyStockAdjustmentDetail] FOREIGN KEY ([StockAdjustmentID]) REFERENCES [Items].[t_StockAdjustment] ([ID])
GO
ALTER TABLE [Items].[t_StockAdjustmentDetail] ADD CONSTRAINT [UnityItemKeyStockAdjustmentDetail] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
