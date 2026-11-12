CREATE TABLE [Invoices].[t_TransferAwaited]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransferAwaited_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_TransferAwaited_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_RefF] DEFAULT ('0'),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_TransferAwaited_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_TransferAwaited_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_TransferAwaited_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_TransferAwaited_DateYearly] DEFAULT (getdate()),
[FromWarehouseID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransferAwaited_FromWarehouseID] DEFAULT ([Company].[f_WareHouseGetFirstID]()),
[FromWarehouse] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_FromWarehouse] DEFAULT ([Company].[f_WareHouseGetFirstName]()),
[ToWarehouseID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransferAwaited_ToWarehouseID] DEFAULT ([Company].[f_WareHouseGetFirstID]()),
[ToWarehouse] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_ToWarehouse] DEFAULT ([Company].[f_WareHouseGetFirstName]()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransferAwaited_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransferAwaited_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_TransferAwaited_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_TransferAwaited_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_TransferAwaited_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Total] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_TotalEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_TransferAwaited_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_TaxValueEuro] DEFAULT ((0)),
[NetIs] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_NetIs] DEFAULT ((0)),
[NetIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_NetIsF] DEFAULT ('0'),
[NetIsD] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_NetIsD] DEFAULT ((0)),
[NetIsLL] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_NetIsLL] DEFAULT ((0)),
[NetIsEuro] [float] NOT NULL CONSTRAINT [DF_t_TransferAwaited_NetIsEuro] DEFAULT ((0)),
[NetIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_NetIsAR] DEFAULT (''),
[NetIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_NetIsEN] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_DescriptionIs] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransferAwaited_ItemsNames] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_TransferAwaited_Qtys] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_TransferAwaited_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_TransferAwaited_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_TransferAwaited]
ON [Invoices].[t_TransferAwaited]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, TransferIs, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Invoices].[t_TransferAwaited] ADD CONSTRAINT [PK_t_TransferAwaited] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_TransferAwaited] ADD CONSTRAINT [CurrencyKeyTransferAwaited] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_TransferAwaited] ADD CONSTRAINT [UserKeyTransferAwaited] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Invoices].[t_TransferAwaited] ADD CONSTRAINT [WareHouseFromKeyTransferAwaited] FOREIGN KEY ([FromWarehouseID]) REFERENCES [Company].[t_WareHouse] ([ID])
GO
ALTER TABLE [Invoices].[t_TransferAwaited] ADD CONSTRAINT [WareHouseToKeyTransferAwaited] FOREIGN KEY ([ToWarehouseID]) REFERENCES [Company].[t_WareHouse] ([ID])
GO
