CREATE TABLE [Invoices].[t_InternetSubscriptionHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_RefF] DEFAULT ('0'),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_DateYearly] DEFAULT (getdate()),
[StartFrom] [date] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_StartFrom] DEFAULT (getdate()),
[ActiveTo] [date] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ActiveTo] DEFAULT (getdate()),
[CustomerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_CustomerID] DEFAULT ([Customers].[f_CustomerGetFirstID]()),
[Customer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_Customer] DEFAULT ([Customers].[f_CustomerGetFirstName]()),
[AccountSaleID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_AccountSaleID] DEFAULT ([Company].[f_AccountSalesGetFirstID]()),
[AccountSale] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_AccountSale] DEFAULT ([Company].[f_AccountSalesGetFirstName]()),
[AccountSaleNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_AccountSaleNumberF] DEFAULT ([Company].[f_AccountSalesGetFirstNumberF]()),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_AccountBoxID] DEFAULT ([Company].[f_AccountBoxGetFirstID]()),
[AccountBox] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_AccountBox] DEFAULT ([Company].[f_AccountBoxGetFirstName]()),
[AccountBoxNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_AccountBoxNumberF] DEFAULT ([Company].[f_AccountBoxGetFirstNumberF]()),
[InternetPackageID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_InternetPackageID] DEFAULT ([Customers].[f_InternetPackageGetFirstID]()),
[InternetPackage] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_InternetPackage] DEFAULT ([Customers].[f_InternetPackageGetFirstName]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_CostEuro] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_PriceEuro] DEFAULT ((0)),
[PriceAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_PriceAR] DEFAULT (''),
[PriceEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_PriceEN] DEFAULT (''),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ProfitEuro] DEFAULT ((0)),
[Paid] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_Paid] DEFAULT ((0)),
[PaidF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_PaidF] DEFAULT ('0'),
[PaidD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_PaidD] DEFAULT ((0)),
[PaidLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_PaidLL] DEFAULT ((0)),
[PaidEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_PaidEuro] DEFAULT ((0)),
[RestIs] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_RestIs] DEFAULT ((0)),
[RestIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_RestIsF] DEFAULT ('0'),
[RestIsD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_RestIsD] DEFAULT ((0)),
[RestIsLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_RestIsLL] DEFAULT ((0)),
[RestIsEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_RestIsEuro] DEFAULT ((0)),
[ProfitCollected] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ProfitCollected] DEFAULT ((0)),
[ProfitCollectedF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ProfitCollectedF] DEFAULT ('0'),
[ProfitCollectedD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ProfitCollectedD] DEFAULT ((0)),
[ProfitCollectedLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ProfitCollectedLL] DEFAULT ((0)),
[ProfitCollectedEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_ProfitCollectedEuro] DEFAULT ((0)),
[PatmentStatus] [tinyint] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_PatmentStatus] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_InternetSubscriptionHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_InternetSubscriptionHistory] ADD CONSTRAINT [PK_t_InternetSubscriptionHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_InternetSubscriptionHistory] ADD CONSTRAINT [AccountBoxKeyInternetSubscriptionHistory] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_InternetSubscriptionHistory] ADD CONSTRAINT [AccountSaleKeyInternetSubscriptionHistory] FOREIGN KEY ([AccountSaleID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_InternetSubscriptionHistory] ADD CONSTRAINT [CurrencyKeyInternetSubscriptionHistory] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_InternetSubscriptionHistory] ADD CONSTRAINT [CustomerKeyInternetSubscriptionHistory] FOREIGN KEY ([CustomerID]) REFERENCES [Customers].[t_Customer] ([ID])
GO
ALTER TABLE [Invoices].[t_InternetSubscriptionHistory] ADD CONSTRAINT [InternetPackageKeyInternetSubscriptionHistory] FOREIGN KEY ([InternetPackageID]) REFERENCES [Customers].[t_InternetPackage] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unpaid = 0
Part = 1
Paid = 2', 'SCHEMA', N'Invoices', 'TABLE', N't_InternetSubscriptionHistory', 'COLUMN', N'PatmentStatus'
GO
