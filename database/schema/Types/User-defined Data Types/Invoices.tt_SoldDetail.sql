CREATE TYPE [Invoices].[tt_SoldDetail] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL,
[Qtys] [decimal] (18, 4) NOT NULL,
[Price] [float] NOT NULL,
[DiscountIs] [decimal] (4, 2) NOT NULL,
[DiscountIsValue] [float] NOT NULL,
[SubTotal] [float] NOT NULL,
[DiscountInvoice] [float] NOT NULL,
[TaxRate] [decimal] (4, 2) NOT NULL,
[TaxValue] [float] NOT NULL,
[Total] [float] NOT NULL,
[Cost] [float] NOT NULL,
[Profit] [float] NOT NULL,
[ProfitTotal] [float] NOT NULL,
[RefPurchaseOrder] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[SortAt] [float] NOT NULL
)
GO
