CREATE TABLE [Invoices].[t_SoldDeleted]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeleted_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_SoldDeleted_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_RefPaper] DEFAULT (''),
[RefPurchaseOrder] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_RefPurchaseOrder] DEFAULT (''),
[SaveFrom] [tinyint] NOT NULL CONSTRAINT [DF_t_SoldDeleted_SaveFrom] DEFAULT ((0)),
[QuotationID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeleted_QuotationID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[QuotationRef] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_QuotationRef] DEFAULT (''),
[InvoiceTitleID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeleted_InvoiceTitleID] DEFAULT ([Invoices].[f_InvoiceTitleGetFirstID]()),
[InvoiceTitle] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_InvoiceTitle] DEFAULT ([Invoices].[f_InvoiceTitleGetFirstName]()),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_SoldDeleted_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_SoldDeleted_DateOnly] DEFAULT (getdate()),
[TimeOnly] [time] NOT NULL CONSTRAINT [DF_t_SoldDeleted_TimeOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_SoldDeleted_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_SoldDeleted_DateYearly] DEFAULT (getdate()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeleted_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[SalespersonID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeleted_SalespersonID] DEFAULT ([Employees].[f_SalesPersonGetFirstID]()),
[Salesperson] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_Salesperson] DEFAULT ([Employees].[f_SalesPersonGetFirstName]()),
[CommissionRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionRate] DEFAULT ((0)),
[CommissionRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionRateF] DEFAULT ('0 %'),
[CommissionRateType] [tinyint] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionRateType] DEFAULT ((0)),
[CommissionRateOn] [tinyint] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionRateOn] DEFAULT ((0)),
[StatusPayment] [tinyint] NOT NULL CONSTRAINT [DF_t_SoldDeleted_StatusPayment] DEFAULT ((1)),
[CommissionValue] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionValue] DEFAULT ((0)),
[CommissionValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionValueF] DEFAULT ('0'),
[CommissionValueD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionValueD] DEFAULT ((0)),
[CommissionValueLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionValueLL] DEFAULT ((0)),
[CommissionValueEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionValueEuro] DEFAULT ((0)),
[SalespersonTakeCommission] [bit] NOT NULL CONSTRAINT [DF_t_SoldDeleted_SalespersonTakeCommission] DEFAULT ((1)),
[CommissionAvailableValue] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionAvailableValue] DEFAULT ((0)),
[CommissionAvailableValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionAvailableValueF] DEFAULT ('0'),
[CommissionAvailableValueD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionAvailableValueD] DEFAULT ((0)),
[CommissionAvailableValueLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionAvailableValueLL] DEFAULT ((0)),
[CommissionAvailableValueEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CommissionAvailableValueEuro] DEFAULT ((0)),
[AccountCustomerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeleted_AccountCustomerID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountCustomer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_AccountCustomer] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountCustomerNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_AccountCustomerNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeleted_AccountBoxID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[AccountBox] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_AccountBox] DEFAULT (''),
[AccountBoxNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_AccountBoxNumber] DEFAULT (''),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_SoldDeleted_PaymentMethod] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SoldDeleted_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SoldDeleted_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SoldDeleted_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[TaxExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SoldDeleted_TaxExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[TaxExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SoldDeleted_TaxExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Total] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_TotalEuro] DEFAULT ((0)),
[DiscountIs] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_DiscountIsF] DEFAULT ('0'),
[DiscountIsD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_DiscountIsD] DEFAULT ((0)),
[DiscountIsLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_DiscountIsLL] DEFAULT ((0)),
[DiscountIsEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_DiscountIsEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_SoldDeleted_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_TaxValueEuro] DEFAULT ((0)),
[NetIs] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_NetIs] DEFAULT ((0)),
[NetIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_NetIsF] DEFAULT ('0'),
[NetIsD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_NetIsD] DEFAULT ((0)),
[NetIsLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_NetIsLL] DEFAULT ((0)),
[NetIsEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_NetIsEuro] DEFAULT ((0)),
[NetIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_NetIsAR] DEFAULT (''),
[NetIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_NetIsEN] DEFAULT (''),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_ProfitEuro] DEFAULT ((0)),
[FirstPayment] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_FirstPayment] DEFAULT ((0)),
[FirstPaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_FirstPaymentF] DEFAULT ('0'),
[FirstPaymentD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_FirstPaymentD] DEFAULT ((0)),
[FirstPaymentLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_FirstPaymentLL] DEFAULT ((0)),
[FirstPaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_FirstPaymentEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeleted_CostEuro] DEFAULT ((0)),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_SoldDeleted_Qtys] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_DescriptionIs] DEFAULT (''),
[WFPFrom] [bit] NOT NULL CONSTRAINT [DF_t_SoldDeleted_WFPFrom] DEFAULT ((0)),
[WFPShopID] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_WFPShopID] DEFAULT (''),
[WFPBranchID] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_WFPBranchID] DEFAULT (''),
[WFPReported] [bit] NOT NULL CONSTRAINT [DF_t_SoldDeleted_WFPReported] DEFAULT ((1)),
[FrameJobOrderID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeleted_FrameJobOrderID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[FrameJobOrderRefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_FrameJobOrderRefF] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeleted_ItemsNames] DEFAULT (''),
[ItemHaveDiscount] [bit] NOT NULL CONSTRAINT [DF_t_SoldDeleted_ItemHaveDiscount] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SoldDeleted_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SoldDeleted_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SoldDeleted_WorkStationID] DEFAULT ((1))
) ON [Invoices] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_SoldDeleted] ADD CONSTRAINT [PK_t_SoldDeleted] PRIMARY KEY CLUSTERED  ([ID]) ON [Invoices]
GO
ALTER TABLE [Invoices].[t_SoldDeleted] WITH NOCHECK ADD CONSTRAINT [AccountBoxKeySoldDeleted] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID]) NOT FOR REPLICATION
GO
ALTER TABLE [Invoices].[t_SoldDeleted] ADD CONSTRAINT [AccountCustomerKeySoldDeleted] FOREIGN KEY ([AccountCustomerID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDeleted] ADD CONSTRAINT [CurrencyKeySoldDeleted] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDeleted] ADD CONSTRAINT [InvoiceTitleKeySoldDeleted] FOREIGN KEY ([InvoiceTitleID]) REFERENCES [Invoices].[t_InvoiceTitle] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDeleted] ADD CONSTRAINT [SalesPersonKeySoldDeleted] FOREIGN KEY ([SalespersonID]) REFERENCES [Employees].[t_SalesPerson] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDeleted] ADD CONSTRAINT [UserKeySoldDeleted] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDeleted] NOCHECK CONSTRAINT [AccountBoxKeySoldDeleted]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Net = 0
Profit = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeleted', 'COLUMN', N'CommissionRateOn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales = 0
Collection = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeleted', 'COLUMN', N'CommissionRateType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'cash = 0
onAccount = 1
schedulePayment = 2', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeleted', 'COLUMN', N'PaymentMethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal = 0
Quotation = 1
FrameJobOrder = 2', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeleted', 'COLUMN', N'SaveFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'not Collected = 0
collection = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeleted', 'COLUMN', N'StatusPayment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeleted', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeleted', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeleted', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeleted', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldDeleted', 'COLUMN', N'TotalLL'
GO
ALTER TABLE [Invoices].[t_SoldDeleted] NOCHECK CONSTRAINT [AccountBoxKeySoldDeleted]
GO
ALTER TABLE [Invoices].[t_SoldDeleted] NOCHECK CONSTRAINT [AccountBoxKeySoldDeleted]
GO
