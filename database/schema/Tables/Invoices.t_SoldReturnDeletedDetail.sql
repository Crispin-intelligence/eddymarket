CREATE TABLE [Invoices].[t_SoldReturnDeletedDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_ID] DEFAULT (newsequentialid()),
[SoldReturnDeletedID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_QtyWithUnity] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_Qtys] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_PriceEuro] DEFAULT ((0)),
[DiscountIs] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountIsF] DEFAULT ('0 %'),
[DiscountIsValue] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountIsValue] DEFAULT ((0)),
[DiscountIsValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountIsValueF] DEFAULT ('0'),
[DiscountIsValueD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountIsValueD] DEFAULT ((0)),
[DiscountIsValueLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountIsValueLL] DEFAULT ((0)),
[DiscountIsValueEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountIsValueEuro] DEFAULT ((0)),
[SubTotal] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_SubTotal] DEFAULT ((0)),
[SubTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_SubTotalF] DEFAULT ('0'),
[SubTotalD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_SubTotalD] DEFAULT ((0)),
[SubTotalLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_SubTotalLL] DEFAULT ((0)),
[SubTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_SubTotalEuro] DEFAULT ((0)),
[DiscountInvoice] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountInvoice] DEFAULT ((0)),
[DiscountInvoiceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountInvoiceF] DEFAULT ('0'),
[DiscountInvoiceD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountInvoiceD] DEFAULT ((0)),
[DiscountInvoiceLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountInvoiceLL] DEFAULT ((0)),
[DiscountInvoiceEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DiscountInvoiceEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_TaxValueEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_TotalEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_CostEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_ProfitEuro] DEFAULT ((0)),
[ProfitTotal] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_ProfitTotal] DEFAULT ((0)),
[ProfitTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_ProfitTotalF] DEFAULT ('0'),
[ProfitTotalD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_ProfitTotalD] DEFAULT ((0)),
[ProfitTotalLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_ProfitTotalLL] DEFAULT ((0)),
[ProfitTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_ProfitTotalEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetail_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SoldReturnDeletedDetails_WorkStationID] DEFAULT ((1))
) ON [Invoices] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_SoldReturnDeletedDetail] ADD CONSTRAINT [PK_t_SoldReturnDeletedDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [Invoices]
GO
ALTER TABLE [Invoices].[t_SoldReturnDeletedDetail] ADD CONSTRAINT [ItemKeySoldReturnDeletedDetail] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturnDeletedDetail] ADD CONSTRAINT [ItemSharedKeySoldReturnDeletedDetail] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturnDeletedDetail] ADD CONSTRAINT [SoldReturnDeletedKeySoldReturnDeletedDetail] FOREIGN KEY ([SoldReturnDeletedID]) REFERENCES [Invoices].[t_SoldReturnDeleted] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturnDeletedDetail] ADD CONSTRAINT [UnityItemKeySoldReturnDeletedDetail] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'Cost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'CostD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'CostEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'CostF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'CostLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'SubTotal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'SubTotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'SubTotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'SubTotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'SubTotalLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDeletedDetail', 'COLUMN', N'TotalLL'
GO
