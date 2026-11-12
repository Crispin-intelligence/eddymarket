CREATE TABLE [Quotations].[t_Quotation]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Quotation_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_Quotation_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_RefPaper] DEFAULT (''),
[SaveFrom] [tinyint] NOT NULL CONSTRAINT [DF_t_Quotation_SaveFrom] DEFAULT ((0)),
[SoldID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Quotation_SoldID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[SoldRefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_SoldRefF] DEFAULT (''),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_Quotation_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_Quotation_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_Quotation_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_Quotation_DateYearly] DEFAULT (getdate()),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Quotation_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_AccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[SalespersonID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Quotation_SalespersonID] DEFAULT ([Employees].[f_SalesPersonGetFirstID]()),
[Salesperson] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_Salesperson] DEFAULT ([Employees].[f_SalesPersonGetFirstName]()),
[CommissionRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_Quotation_CommissionRate] DEFAULT ((0)),
[CommissionRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_CommissionRateF] DEFAULT ('0 %'),
[CommissionRateType] [tinyint] NOT NULL CONSTRAINT [DF_t_Quotation_CommissionRateType] DEFAULT ((0)),
[CommissionValue] [float] NOT NULL CONSTRAINT [DF_t_Quotation_CommissionValue] DEFAULT ((0)),
[CommissionValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_CommissionValueF] DEFAULT ('0'),
[CommissionValueD] [float] NOT NULL CONSTRAINT [DF_t_Quotation_CommissionValueD] DEFAULT ((0)),
[CommissionValueLL] [float] NOT NULL CONSTRAINT [DF_t_Quotation_CommissionValueLL] DEFAULT ((0)),
[CommissionValueEuro] [float] NOT NULL CONSTRAINT [DF_t_Quotation_CommissionValueEuro] DEFAULT ((0)),
[AttentionTo] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_AttentionTo] DEFAULT (''),
[SubjectIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_SubjectIs] DEFAULT (''),
[WarrantyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Quotation_WarrantyID] DEFAULT ([Quotations].[f_QuotationWarrantyGetFirstID]()),
[Warranty] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_Warranty] DEFAULT ([Quotations].[f_QuotationWarrantyGetFirstName]()),
[TypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Quotation_TypeID] DEFAULT ([Quotations].[f_QuotationTypeGetFirstID]()),
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_TypeIs] DEFAULT ([Quotations].[f_QuotationTypeGetFirstName]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Quotation_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Quotation_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Quotation_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Quotation_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Total] [float] NOT NULL CONSTRAINT [DF_t_Quotation_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_Quotation_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_Quotation_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_Quotation_TotalEuro] DEFAULT ((0)),
[DiscountIs] [float] NOT NULL CONSTRAINT [DF_t_Quotation_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_DiscountIsF] DEFAULT ('0'),
[DiscountIsD] [float] NOT NULL CONSTRAINT [DF_t_Quotation_DiscountIsD] DEFAULT ((0)),
[DiscountIsLL] [float] NOT NULL CONSTRAINT [DF_t_Quotation_DiscountIsLL] DEFAULT ((0)),
[DiscountIsEuro] [float] NOT NULL CONSTRAINT [DF_t_Quotation_DiscountIsEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_Quotation_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_Quotation_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_Quotation_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_Quotation_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_Quotation_TaxValueEuro] DEFAULT ((0)),
[NetIs] [float] NOT NULL CONSTRAINT [DF_t_Quotation_NetIs] DEFAULT ((0)),
[NetIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_NetIsF] DEFAULT ('0'),
[NetIsD] [float] NOT NULL CONSTRAINT [DF_t_Quotation_NetIsD] DEFAULT ((0)),
[NetIsLL] [float] NOT NULL CONSTRAINT [DF_t_Quotation_NetIsLL] DEFAULT ((0)),
[NetIsEuro] [float] NOT NULL CONSTRAINT [DF_t_Quotation_NetIsEuro] DEFAULT ((0)),
[NetIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_NetIsAR] DEFAULT (''),
[NetIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_NetIsEN] DEFAULT (''),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_Quotation_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_Quotation_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_Quotation_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_Quotation_ProfitEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_Quotation_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_Quotation_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_Quotation_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_Quotation_CostEuro] DEFAULT ((0)),
[Qtys] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Quotation_Qtys] DEFAULT ((0)),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Quotation_Status] DEFAULT ((0)),
[WhyThisStatus] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_WhyThisStatus] DEFAULT (''),
[IsConfirm] [bit] NOT NULL CONSTRAINT [DF_t_Quotation_IsConfirm] DEFAULT ((0)),
[NotificationAfterDays] [tinyint] NOT NULL CONSTRAINT [DF_t_Quotation_NotificationAfterDays] DEFAULT ((0)),
[NotificationDate] [date] NOT NULL CONSTRAINT [DF_t_Quotation_NotificationDate] DEFAULT (getdate()),
[NotificationStop] [bit] NOT NULL CONSTRAINT [DF_t_Quotation_NotificationStop] DEFAULT ((0)),
[NotificationTextAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_NotificationTextAR] DEFAULT (''),
[NotificationTextEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_NotificationTextEN] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_DescriptionIs] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Quotation_ItemsNames] DEFAULT (''),
[ItemHaveDiscount] [bit] NOT NULL CONSTRAINT [DF_t_Quotation_ItemHaveDiscount] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Quotation_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Quotation_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Quotations].[tr_Quotation]
ON [Quotations].[t_Quotation]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Quotation, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaQuotation, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Quotations].[t_Quotation] ADD CONSTRAINT [PK_t_Quotation] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Quotation_Name] ON [Quotations].[t_Quotation] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Quotations].[t_Quotation] ADD CONSTRAINT [AccountKeyQuotation] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Quotations].[t_Quotation] ADD CONSTRAINT [CurrencyKeyQuotation] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Quotations].[t_Quotation] ADD CONSTRAINT [QuotationTypeKeyQuotation] FOREIGN KEY ([TypeID]) REFERENCES [Quotations].[t_QuotationType] ([ID])
GO
ALTER TABLE [Quotations].[t_Quotation] ADD CONSTRAINT [QuotationWarrantyKeyQuotation] FOREIGN KEY ([WarrantyID]) REFERENCES [Quotations].[t_QuotationWarranty] ([ID])
GO
ALTER TABLE [Quotations].[t_Quotation] ADD CONSTRAINT [SalesPersonKeyQuotation] FOREIGN KEY ([SalespersonID]) REFERENCES [Employees].[t_SalesPerson] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales = 0
Collection = 1', 'SCHEMA', N'Quotations', 'TABLE', N't_Quotation', 'COLUMN', N'CommissionRateType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal = 0
Sales Invoice = 1', 'SCHEMA', N'Quotations', 'TABLE', N't_Quotation', 'COLUMN', N'SaveFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal = 0
Priority = 1
High Priority = 2
Pending = 3
Completed = 4
Canceled = 5', 'SCHEMA', N'Quotations', 'TABLE', N't_Quotation', 'COLUMN', N'StatusIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_Quotation', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_Quotation', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_Quotation', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_Quotation', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_Quotation', 'COLUMN', N'TotalLL'
GO
