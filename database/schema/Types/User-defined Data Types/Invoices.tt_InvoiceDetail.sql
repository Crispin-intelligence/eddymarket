CREATE TYPE [Invoices].[tt_InvoiceDetail] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 2) NOT NULL,
[Price] [float] NOT NULL,
[TaxRate] [decimal] (4, 2) NOT NULL,
[TaxValue] [float] NOT NULL,
[DiscountIs] [decimal] (4, 2) NOT NULL,
[DiscountIsValue] [float] NOT NULL,
[Total] [float] NOT NULL,
[Sell] [float] NOT NULL,
[Profit] [float] NOT NULL,
[ProfitTotal] [float] NOT NULL,
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[SortAt] [float] NOT NULL
)
GO
