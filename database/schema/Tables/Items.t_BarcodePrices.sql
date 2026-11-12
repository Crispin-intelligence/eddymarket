CREATE TABLE [Items].[t_BarcodePrices]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BarcodePrices_ID] DEFAULT (newsequentialid()),
[UserID] [int] NOT NULL CONSTRAINT [DF_t_BarcodePrices_UserID] DEFAULT ((1)),
[IsSeason] [bit] NOT NULL CONSTRAINT [DF_t_BarcodePrices_IsSeason] DEFAULT ((0)),
[SeasonFrom] [datetime] NOT NULL CONSTRAINT [DF_t_BarcodePrices_SeasonFrom] DEFAULT (getdate()),
[SeasonTo] [datetime] NOT NULL CONSTRAINT [DF_t_BarcodePrices_SeasonTo] DEFAULT (getdate()),
[SeasonAutoDelete] [bit] NOT NULL CONSTRAINT [DF_t_BarcodePrices_AutoDeleted] DEFAULT ((1)),
[WhyThis] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BarcodePrices_WhyThis] DEFAULT (''),
[IsPause] [bit] NOT NULL CONSTRAINT [DF_t_BarcodePrices_IsPause] DEFAULT ((0)),
[CurrencyID] [int] NOT NULL CONSTRAINT [DF_t_BarcodePrices_CurrencyID] DEFAULT ((1)),
[Conversion] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BarcodePrices_Conversion] DEFAULT ('*'),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_BarcodePrices_ExchangeRate] DEFAULT ((1)),
[Purchase] [float] NOT NULL CONSTRAINT [DF_t_BarcodePrices_Purchase] DEFAULT ((0)),
[PurchaseF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BarcodePrices_PurchaseF] DEFAULT (''),
[PurchaseD] [float] NOT NULL CONSTRAINT [DF_t_BarcodePrices_PurchaseD] DEFAULT ((0)),
[Distributor] [float] NOT NULL CONSTRAINT [DF_t_BarcodePrices_Distributor] DEFAULT ((0)),
[DistributorF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BarcodePrices_DistributorF] DEFAULT (''),
[DistributorD] [float] NOT NULL CONSTRAINT [DF_t_BarcodePrices_DistributorD] DEFAULT ((0)),
[Wholesale] [float] NOT NULL CONSTRAINT [DF_t_BarcodePrices_Wholesale] DEFAULT ((0)),
[WholesaleF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BarcodePrices_WholesaleF] DEFAULT (''),
[WholesaleD] [float] NOT NULL CONSTRAINT [DF_t_BarcodePrices_WholesaleD] DEFAULT ((0)),
[Sell] [float] NOT NULL CONSTRAINT [DF_t_BarcodePrices_Sell] DEFAULT ((0)),
[SellF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BarcodePrices_SellF] DEFAULT (''),
[SellD] [float] NOT NULL CONSTRAINT [DF_t_BarcodePrices_SellD] DEFAULT ((0)),
[Discount] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_BarcodePrices_Discount] DEFAULT ((0)),
[DiscountF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BarcodePrices_DiscountF] DEFAULT (''),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_BarcodePrices_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Items].[t_BarcodePrices] ADD CONSTRAINT [PK_t_BarcodePrices] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
