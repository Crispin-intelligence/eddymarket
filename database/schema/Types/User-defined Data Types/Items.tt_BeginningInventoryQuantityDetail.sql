CREATE TYPE [Items].[tt_BeginningInventoryQuantityDetail] AS TABLE
(
[ID] [uniqueidentifier] NULL,
[ItemSharedID] [uniqueidentifier] NULL,
[ItemID] [uniqueidentifier] NULL,
[ItemUnityID] [uniqueidentifier] NULL,
[Qty] [decimal] (18, 4) NULL,
[Price] [float] NULL,
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NULL,
[SortAt] [float] NULL
)
GO
