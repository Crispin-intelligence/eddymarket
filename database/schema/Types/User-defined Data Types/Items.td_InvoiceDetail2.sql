CREATE TYPE [Items].[td_InvoiceDetail2] AS TABLE
(
[ID] [uniqueidentifier] NULL,
[ItemSharedID] [int] NULL,
[ItemUnityID] [int] NULL,
[Qty] [decimal] (18, 2) NULL,
[Price] [float] NULL,
[SortAt] [float] NULL
)
GO
