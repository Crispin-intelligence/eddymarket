CREATE TABLE [Invoices].[t_PurchasingDeleted]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_RefPaper] DEFAULT (''),
[InvoiceTitleID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_InvoiceTitleID] DEFAULT ([Invoices].[f_InvoiceTitleGetFirstID]()),
[InvoiceTitle] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_InvoiceTitle] DEFAULT ([Invoices].[f_InvoiceTitleGetFirstName]()),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_DateYearly] DEFAULT (getdate()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[AccountVendorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_AccountVendorID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountVendor] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_AccountVendor] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountVendorNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_AccountVendorNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_AccountBoxID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[AccountBox] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_AccountBox] DEFAULT (''),
[AccountBoxNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_AccountBoxNumber] DEFAULT (''),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_PaymentMethod] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[TaxExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TaxExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[TaxExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TaxExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Total] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TotalEuro] DEFAULT ((0)),
[DiscountIs] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_DiscountIsF] DEFAULT ('0'),
[DiscountIsD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_DiscountIsD] DEFAULT ((0)),
[DiscountIsLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_DiscountIsLL] DEFAULT ((0)),
[DiscountIsEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_DiscountIsEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_TaxValueEuro] DEFAULT ((0)),
[NetIs] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_NetIs] DEFAULT ((0)),
[NetIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_NetIsF] DEFAULT ('0'),
[NetIsD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_NetIsD] DEFAULT ((0)),
[NetIsLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_NetIsLL] DEFAULT ((0)),
[NetIsEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_NetIsEuro] DEFAULT ((0)),
[NetIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_NetIsAR] DEFAULT (''),
[NetIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_NetIsEN] DEFAULT (''),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_ProfitEuro] DEFAULT ((0)),
[FirstPayment] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_FirstPayment] DEFAULT ((0)),
[FirstPaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_FirstPaymentF] DEFAULT ('0'),
[FirstPaymentD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_FirstPaymentD] DEFAULT ((0)),
[FirstPaymentLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_FirstPaymentLL] DEFAULT ((0)),
[FirstPaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_FirstPaymentEuro] DEFAULT ((0)),
[Sell] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_Sell] DEFAULT ((0)),
[SellF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_SellF] DEFAULT ('0'),
[SellD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_SellD] DEFAULT ((0)),
[SellLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_SellLL] DEFAULT ((0)),
[SellEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_SellEuro] DEFAULT ((0)),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_Qtys] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_DescriptionIs] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_ItemsNames] DEFAULT (''),
[ItemHaveDiscount] [bit] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_ItemHaveDiscount] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_PurchasingDeleted_WorkStationID] DEFAULT ((1))
) ON [Invoices] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_PurchasingDeleted] ADD CONSTRAINT [PK_t_PurchasingDeleted] PRIMARY KEY CLUSTERED  ([ID]) ON [Invoices]
GO
ALTER TABLE [Invoices].[t_PurchasingDeleted] WITH NOCHECK ADD CONSTRAINT [AccountBoxKeyPurchasingDeleted] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID]) NOT FOR REPLICATION
GO
ALTER TABLE [Invoices].[t_PurchasingDeleted] ADD CONSTRAINT [AccountVendorKeyPurchasingDeleted] FOREIGN KEY ([AccountVendorID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingDeleted] ADD CONSTRAINT [CurrencyKeyPurchasingDeleted] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingDeleted] ADD CONSTRAINT [InvoiceTitleKeyPurchasingDeleted] FOREIGN KEY ([InvoiceTitleID]) REFERENCES [Invoices].[t_InvoiceTitle] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingDeleted] ADD CONSTRAINT [UserKeyPurchasingDeleted] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingDeleted] NOCHECK CONSTRAINT [AccountBoxKeyPurchasingDeleted]
GO
EXEC sp_addextendedproperty N'MS_Description', N'cash = 0
onAccount = 1
schedulePayment = 2', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDeleted', 'COLUMN', N'PaymentMethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDeleted', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDeleted', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDeleted', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDeleted', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDeleted', 'COLUMN', N'TotalLL'
GO
ALTER TABLE [Invoices].[t_PurchasingDeleted] NOCHECK CONSTRAINT [AccountBoxKeyPurchasingDeleted]
GO
