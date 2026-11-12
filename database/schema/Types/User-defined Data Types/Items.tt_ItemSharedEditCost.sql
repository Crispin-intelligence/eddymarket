CREATE TYPE [Items].[tt_ItemSharedEditCost] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[Cost] [float] NOT NULL,
[CurrencyID] [uniqueidentifier] NOT NULL,
[Discount] [decimal] (4, 2) NOT NULL,
[TaxRate] [decimal] (4, 2) NOT NULL,
[EventIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
