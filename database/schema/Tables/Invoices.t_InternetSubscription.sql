CREATE TABLE [Invoices].[t_InternetSubscription]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscription_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_InternetSubscription_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_RefF] DEFAULT ('0'),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_InternetSubscription_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_InternetSubscription_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_InternetSubscription_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_InternetSubscription_DateYearly] DEFAULT (getdate()),
[StartFrom] [date] NOT NULL CONSTRAINT [DF_t_InternetSubscription_StartFrom] DEFAULT (getdate()),
[ActiveTo] [date] NOT NULL CONSTRAINT [DF_t_InternetSubscription_ActiveTo] DEFAULT (getdate()),
[CustomerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscription_CustomerID] DEFAULT ([Customers].[f_CustomerGetFirstID]()),
[Customer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_Customer] DEFAULT ([Customers].[f_CustomerGetFirstName]()),
[AccountSaleID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscription_AccountSaleID] DEFAULT ([Company].[f_AccountSalesGetFirstID]()),
[AccountSale] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_AccountSale] DEFAULT ([Company].[f_AccountSalesGetFirstName]()),
[AccountSaleNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_AccountSaleNumberF] DEFAULT ([Company].[f_AccountSalesGetFirstNumberF]()),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscription_AccountBoxID] DEFAULT ([Company].[f_AccountBoxGetFirstID]()),
[AccountBox] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_AccountBox] DEFAULT ([Company].[f_AccountBoxGetFirstName]()),
[AccountBoxNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_AccountBoxNumberF] DEFAULT ([Company].[f_AccountBoxGetFirstNumberF]()),
[InternetPackageID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscription_InternetPackageID] DEFAULT ([Customers].[f_InternetPackageGetFirstID]()),
[InternetPackage] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_InternetPackage] DEFAULT ([Customers].[f_InternetPackageGetFirstName]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetSubscription_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_InternetSubscription_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_CostEuro] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_PriceEuro] DEFAULT ((0)),
[PriceAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_PriceAR] DEFAULT (''),
[PriceEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_PriceEN] DEFAULT (''),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_ProfitEuro] DEFAULT ((0)),
[Paid] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_Paid] DEFAULT ((0)),
[PaidF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_PaidF] DEFAULT ('0'),
[PaidD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_PaidD] DEFAULT ((0)),
[PaidLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_PaidLL] DEFAULT ((0)),
[PaidEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_PaidEuro] DEFAULT ((0)),
[RestIs] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_RestIs] DEFAULT ((0)),
[RestIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_RestIsF] DEFAULT ('0'),
[RestIsD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_RestIsD] DEFAULT ((0)),
[RestIsLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_RestIsLL] DEFAULT ((0)),
[RestIsEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_RestIsEuro] DEFAULT ((0)),
[ProfitCollected] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_ProfitCollected] DEFAULT ((0)),
[ProfitCollectedF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_ProfitCollectedF] DEFAULT ('0'),
[ProfitCollectedD] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_ProfitCollectedD] DEFAULT ((0)),
[ProfitCollectedLL] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_ProfitCollectedLL] DEFAULT ((0)),
[ProfitCollectedEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetSubscription_ProfitCollectedEuro] DEFAULT ((0)),
[PatmentStatus] [tinyint] NOT NULL CONSTRAINT [DF_t_InternetSubscription_PatmentStatus] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetSubscription_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_InternetSubscription_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_InternetSubscription_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_InternetSubscription]
ON [Invoices].[t_InternetSubscription]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, InternetSubscription, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Invoices].[t_InternetSubscription] ADD CONSTRAINT [PK_t_InternetSubscription] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_InternetSubscription_Ref] ON [Invoices].[t_InternetSubscription] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_InternetSubscription] ADD CONSTRAINT [AccountBoxKeyInternetSubscription] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_InternetSubscription] ADD CONSTRAINT [AccountSaleKeyInternetSubscription] FOREIGN KEY ([AccountSaleID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_InternetSubscription] ADD CONSTRAINT [CurrencyKeyInternetSubscription] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_InternetSubscription] ADD CONSTRAINT [CustomerKeyInternetSubscription] FOREIGN KEY ([CustomerID]) REFERENCES [Customers].[t_Customer] ([ID])
GO
ALTER TABLE [Invoices].[t_InternetSubscription] ADD CONSTRAINT [InternetPackageKeyInternetSubscription] FOREIGN KEY ([InternetPackageID]) REFERENCES [Customers].[t_InternetPackage] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unpaid = 0
Part = 1
Paid = 2', 'SCHEMA', N'Invoices', 'TABLE', N't_InternetSubscription', 'COLUMN', N'PatmentStatus'
GO
