CREATE TYPE [Items].[tt_ItemSharedEditSell] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[PrimaryIs] [bit] NOT NULL,
[Price] [float] NOT NULL,
[CurrencyID] [uniqueidentifier] NOT NULL,
[LowestPrice] [float] NOT NULL,
[EventIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
