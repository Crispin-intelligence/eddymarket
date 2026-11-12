CREATE TYPE [Items].[tt_StockAdjustmentDetail] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL,
[Price] [float] NOT NULL,
[Total] [float] NOT NULL,
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[SortAt] [float] NOT NULL
)
GO
