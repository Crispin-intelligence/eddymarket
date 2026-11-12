CREATE TABLE [Quotations].[t_QuotationHistoryDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_ID] DEFAULT (newsequentialid()),
[QuotationHistoryID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_QtyWithUnity] DEFAULT ('0'),
[Qtys] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_Qtys] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_PriceEuro] DEFAULT ((0)),
[DiscountIs] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountIsF] DEFAULT ('0 %'),
[DiscountIsValue] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountIsValue] DEFAULT ((0)),
[DiscountIsValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountIsValueF] DEFAULT ('0'),
[DiscountIsValueD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountIsValueD] DEFAULT ((0)),
[DiscountIsValueLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountIsValueLL] DEFAULT ((0)),
[DiscountIsValueEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountIsValueEuro] DEFAULT ((0)),
[SubTotal] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_SubTotal] DEFAULT ((0)),
[SubTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_SubTotalF] DEFAULT ('0'),
[SubTotalD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_SubTotalD] DEFAULT ((0)),
[SubTotalLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_SubTotalLL] DEFAULT ((0)),
[SubTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_SubTotalEuro] DEFAULT ((0)),
[DiscountQuotation] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountQuotation] DEFAULT ((0)),
[DiscountQuotationF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountQuotationF] DEFAULT ('0'),
[DiscountQuotationD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountQuotationD] DEFAULT ((0)),
[DiscountQuotationLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountQuotationLL] DEFAULT ((0)),
[DiscountQuotationEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DiscountQuotationEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_TaxValueEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_TotalEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_CostEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_ProfitEuro] DEFAULT ((0)),
[ProfitTotal] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_ProfitTotal] DEFAULT ((0)),
[ProfitTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_ProfitTotalF] DEFAULT ('0'),
[ProfitTotalD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_ProfitTotalD] DEFAULT ((0)),
[ProfitTotalLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_ProfitTotalLL] DEFAULT ((0)),
[ProfitTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_ProfitTotalEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_QuotationHistoryDetail_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Quotations].[t_QuotationHistoryDetail] ADD CONSTRAINT [PK_t_QuotationHistoryDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Quotations].[t_QuotationHistoryDetail] ADD CONSTRAINT [ItemSharedKeyQuotationHistoryDetail] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Quotations].[t_QuotationHistoryDetail] ADD CONSTRAINT [QuotationHistoryKeyQuotationHistoryDetail] FOREIGN KEY ([QuotationHistoryID]) REFERENCES [Quotations].[t_QuotationHistory] ([ID])
GO
ALTER TABLE [Quotations].[t_QuotationHistoryDetail] ADD CONSTRAINT [UnityItemKeyQuotationHistoryDetail] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'Cost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'CostD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'CostEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'CostF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'CostLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'DiscountIsValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'DiscountIsValueD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'DiscountIsValueEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'DiscountIsValueF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'DiscountIsValueLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'TaxValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'TaxValueD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'TaxValueEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'TaxValueF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'TaxValueLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistoryDetail', 'COLUMN', N'TotalLL'
GO
