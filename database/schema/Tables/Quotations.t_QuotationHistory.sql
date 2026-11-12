CREATE TABLE [Quotations].[t_QuotationHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationHistory_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_QuotationHistory_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_RefPaper] DEFAULT (''),
[SaveFrom] [tinyint] NOT NULL CONSTRAINT [DF_t_QuotationHistory_SaveFrom] DEFAULT ((0)),
[SoldID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationHistory_SoldID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[SoldRefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_SoldRefF] DEFAULT (''),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_QuotationHistory_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_QuotationHistory_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_QuotationHistory_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_QuotationHistory_DateYearly] DEFAULT (getdate()),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationHistory_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_AccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[SalespersonID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationHistory_SalespersonID] DEFAULT ([Employees].[f_SalesPersonGetFirstID]()),
[Salesperson] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_Salesperson] DEFAULT ([Employees].[f_SalesPersonGetFirstName]()),
[CommissionRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_QuotationHistory_CommissionRate] DEFAULT ((0)),
[CommissionRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_CommissionRateF] DEFAULT ('0 %'),
[CommissionRateType] [tinyint] NOT NULL CONSTRAINT [DF_t_QuotationHistory_CommissionRateType] DEFAULT ((0)),
[CommissionValue] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_CommissionValue] DEFAULT ((0)),
[CommissionValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_CommissionValueF] DEFAULT ('0'),
[CommissionValueD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_CommissionValueD] DEFAULT ((0)),
[CommissionValueLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_CommissionValueLL] DEFAULT ((0)),
[CommissionValueEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_CommissionValueEuro] DEFAULT ((0)),
[AttentionTo] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_AttentionTo] DEFAULT (''),
[SubjectIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_SubjectIs] DEFAULT (''),
[WarrantyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationHistory_WarrantyID] DEFAULT ([Quotations].[f_QuotationWarrantyGetFirstID]()),
[Warranty] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_Warranty] DEFAULT ([Quotations].[f_QuotationWarrantyGetFirstName]()),
[TypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationHistory_TypeID] DEFAULT ([Quotations].[f_QuotationTypeGetFirstID]()),
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_TypeIs] DEFAULT ([Quotations].[f_QuotationTypeGetFirstName]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationHistory_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_QuotationHistory_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_QuotationHistory_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_QuotationHistory_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Total] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_TotalEuro] DEFAULT ((0)),
[DiscountIs] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_DiscountIsF] DEFAULT ('0'),
[DiscountIsD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_DiscountIsD] DEFAULT ((0)),
[DiscountIsLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_DiscountIsLL] DEFAULT ((0)),
[DiscountIsEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_DiscountIsEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_QuotationHistory_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_TaxValueEuro] DEFAULT ((0)),
[NetIs] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_NetIs] DEFAULT ((0)),
[NetIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_NetIsF] DEFAULT ('0'),
[NetIsD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_NetIsD] DEFAULT ((0)),
[NetIsLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_NetIsLL] DEFAULT ((0)),
[NetIsEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_NetIsEuro] DEFAULT ((0)),
[NetIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_NetIsAR] DEFAULT (''),
[NetIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_NetIsEN] DEFAULT (''),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_ProfitEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationHistory_CostEuro] DEFAULT ((0)),
[Qtys] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_QuotationHistory_Qtys] DEFAULT ((0)),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_QuotationHistory_Status] DEFAULT ((0)),
[WhyThisStatus] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_WhyThisStatus] DEFAULT (''),
[IsConfirm] [bit] NOT NULL CONSTRAINT [DF_t_QuotationHistory_IsConfirm] DEFAULT ((0)),
[NotificationAfterDays] [tinyint] NOT NULL CONSTRAINT [DF_t_QuotationHistory_NotificationAfterDays] DEFAULT ((0)),
[NotificationDate] [date] NOT NULL CONSTRAINT [DF_t_QuotationHistory_NotificationDate] DEFAULT (getdate()),
[NotificationStop] [bit] NOT NULL CONSTRAINT [DF_t_QuotationHistory_NotificationStop] DEFAULT ((0)),
[NotificationTextAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_NotificationTextAR] DEFAULT (''),
[NotificationTextEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_NotificationTextEN] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_DescriptionIs] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationHistory_ItemsNames] DEFAULT (''),
[ItemHaveDiscount] [bit] NOT NULL CONSTRAINT [DF_t_QuotationHistory_ItemHaveDiscount] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_QuotationHistory_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_QuotationHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Quotations].[tr_QuotationHistory]
ON [Quotations].[t_QuotationHistory]
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
ALTER TABLE [Quotations].[t_QuotationHistory] ADD CONSTRAINT [PK_t_QuotationHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Quotations].[t_QuotationHistory] ADD CONSTRAINT [AccountKeyQuotationHistory] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Quotations].[t_QuotationHistory] ADD CONSTRAINT [CurrencyKeyQuotationHistory] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Quotations].[t_QuotationHistory] ADD CONSTRAINT [QuotationTypeKeyQuotationHistory] FOREIGN KEY ([TypeID]) REFERENCES [Quotations].[t_QuotationType] ([ID])
GO
ALTER TABLE [Quotations].[t_QuotationHistory] ADD CONSTRAINT [QuotationWarrantyKeyQuotationHistory] FOREIGN KEY ([WarrantyID]) REFERENCES [Quotations].[t_QuotationWarranty] ([ID])
GO
ALTER TABLE [Quotations].[t_QuotationHistory] ADD CONSTRAINT [SalesPersonKeyQuotationHistory] FOREIGN KEY ([SalespersonID]) REFERENCES [Employees].[t_SalesPerson] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales = 0
Collection = 1', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistory', 'COLUMN', N'CommissionRateType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal = 0
Sales Invoice = 1', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistory', 'COLUMN', N'SaveFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal = 0
Priority = 1
High Priority = 2
Pending = 3
Completed = 4
Canceled = 5', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistory', 'COLUMN', N'StatusIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistory', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistory', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistory', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistory', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Quotations', 'TABLE', N't_QuotationHistory', 'COLUMN', N'TotalLL'
GO
