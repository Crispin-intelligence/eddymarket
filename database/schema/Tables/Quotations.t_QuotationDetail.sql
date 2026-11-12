CREATE TABLE [Quotations].[t_QuotationDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationDetail_ID] DEFAULT (newsequentialid()),
[QuotationID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_QuotationDetail_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_QtyWithUnity] DEFAULT ('0'),
[Qtys] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_QuotationDetail_Qtys] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_PriceEuro] DEFAULT ((0)),
[DiscountIs] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountIsF] DEFAULT ('0 %'),
[DiscountIsValue] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountIsValue] DEFAULT ((0)),
[DiscountIsValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountIsValueF] DEFAULT ('0'),
[DiscountIsValueD] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountIsValueD] DEFAULT ((0)),
[DiscountIsValueLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountIsValueLL] DEFAULT ((0)),
[DiscountIsValueEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountIsValueEuro] DEFAULT ((0)),
[SubTotal] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_SubTotal] DEFAULT ((0)),
[SubTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_SubTotalF] DEFAULT ('0'),
[SubTotalD] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_SubTotalD] DEFAULT ((0)),
[SubTotalLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_SubTotalLL] DEFAULT ((0)),
[SubTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_SubTotalEuro] DEFAULT ((0)),
[DiscountQuotation] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountQuotation] DEFAULT ((0)),
[DiscountQuotationF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountQuotationF] DEFAULT ('0'),
[DiscountQuotationD] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountQuotationD] DEFAULT ((0)),
[DiscountQuotationLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountQuotationLL] DEFAULT ((0)),
[DiscountQuotationEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_DiscountQuotationEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_QuotationDetail_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_TaxValueEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_TotalEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_CostEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_ProfitEuro] DEFAULT ((0)),
[ProfitTotal] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_ProfitTotal] DEFAULT ((0)),
[ProfitTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_ProfitTotalF] DEFAULT ('0'),
[ProfitTotalD] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_ProfitTotalD] DEFAULT ((0)),
[ProfitTotalLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_ProfitTotalLL] DEFAULT ((0)),
[ProfitTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_ProfitTotalEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationDetail_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_QuotationDetail_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_QuotationDetail_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_QuotationDetail_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Quotations].[t_QuotationDetail] ADD CONSTRAINT [PK_t_QuotationDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Quotations].[t_QuotationDetail] ADD CONSTRAINT [ItemSharedKeyQuotationDetail] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Quotations].[t_QuotationDetail] ADD CONSTRAINT [QuotationKeyQuotationDetail] FOREIGN KEY ([QuotationID]) REFERENCES [Quotations].[t_Quotation] ([ID])
GO
ALTER TABLE [Quotations].[t_QuotationDetail] ADD CONSTRAINT [UnityItemKeyQuotationDetail] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'Cost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'CostD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'CostEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'CostF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'CostLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'DiscountIsValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'DiscountIsValueD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'DiscountIsValueEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'DiscountIsValueF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'DiscountIsValueLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'TaxValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'TaxValueD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'TaxValueEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'TaxValueF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'TaxValueLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationDetail', 'COLUMN', N'TotalLL'
GO
