CREATE TABLE [Invoices].[t_SoldDeletedDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_ID] DEFAULT (newsequentialid()),
[SoldDeletedID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_QtyWithUnity] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_Qtys] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_PriceEuro] DEFAULT ((0)),
[DiscountIs] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountIsF] DEFAULT ('0 %'),
[DiscountIsValue] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountIsValue] DEFAULT ((0)),
[DiscountIsValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountIsValueF] DEFAULT ('0'),
[DiscountIsValueD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountIsValueD] DEFAULT ((0)),
[DiscountIsValueLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountIsValueLL] DEFAULT ((0)),
[DiscountIsValueEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountIsValueEuro] DEFAULT ((0)),
[SubTotal] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_SubTotal] DEFAULT ((0)),
[SubTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_SubTotalF] DEFAULT ('0'),
[SubTotalD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_SubTotalD] DEFAULT ((0)),
[SubTotalLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_SubTotalLL] DEFAULT ((0)),
[SubTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_SubTotalEuro] DEFAULT ((0)),
[DiscountInvoice] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountInvoice] DEFAULT ((0)),
[DiscountInvoiceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountInvoiceF] DEFAULT ('0'),
[DiscountInvoiceD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountInvoiceD] DEFAULT ((0)),
[DiscountInvoiceLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountInvoiceLL] DEFAULT ((0)),
[DiscountInvoiceEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DiscountInvoiceEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_TaxValueEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_TotalEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_CostEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_ProfitEuro] DEFAULT ((0)),
[ProfitTotal] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_ProfitTotal] DEFAULT ((0)),
[ProfitTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_ProfitTotalF] DEFAULT ('0'),
[ProfitTotalD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_ProfitTotalD] DEFAULT ((0)),
[ProfitTotalLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_ProfitTotalLL] DEFAULT ((0)),
[ProfitTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_ProfitTotalEuro] DEFAULT ((0)),
[RefPurchaseOrder] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_RefPurchaseOrder] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetail_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetails_WorkStationID] DEFAULT ((1))
) ON [Invoices] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_SoldDeletedDetail] ADD CONSTRAINT [PK_t_SoldDeletedDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [Invoices]
GO
ALTER TABLE [Invoices].[t_SoldDeletedDetail] ADD CONSTRAINT [ItemKeySoldDeletedDetail] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDeletedDetail] ADD CONSTRAINT [ItemSharedKeySoldDeletedDetail] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDeletedDetail] ADD CONSTRAINT [SoldDeletedKeySoldDeletedDetail] FOREIGN KEY ([SoldDeletedID]) REFERENCES [Invoices].[t_SoldDeleted] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDeletedDetail] ADD CONSTRAINT [UnityItemKeySoldDeletedDetail] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'Cost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'CostD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'CostEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'CostF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'CostLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'DiscountIsValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'DiscountIsValueD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'DiscountIsValueEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'DiscountIsValueF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'DiscountIsValueLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'SubTotal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'SubTotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'SubTotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'SubTotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'SubTotalLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'TaxValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'TaxValueD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'TaxValueEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'TaxValueF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'TaxValueLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeletedDetail', 'COLUMN', N'TotalLL'
GO
