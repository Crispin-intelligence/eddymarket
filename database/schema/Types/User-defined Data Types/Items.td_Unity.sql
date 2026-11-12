CREATE TYPE [Items].[td_Unity] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[UnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 2) NOT NULL,
[IsPrimary] [bit] NOT NULL,
[Purchasing] [bit] NOT NULL,
[Sold] [bit] NOT NULL,
[Inventory] [bit] NOT NULL,
[UseInTransfer] [bit] NOT NULL,
[BarCode] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[CurrencyID] [uniqueidentifier] NOT NULL,
[Price] [float] NOT NULL,
[LowestPrice] [float] NOT NULL
)
GO
