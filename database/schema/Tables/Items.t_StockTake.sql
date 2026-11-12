CREATE TABLE [Items].[t_StockTake]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_StockTake_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_StockTake_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTake_RefF] DEFAULT ('0'),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_StockTake_TypeIs] DEFAULT ((0)),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_StockTake_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_StockTake_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_StockTake_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_StockTake_DateYearly] DEFAULT (getdate()),
[WarehouseID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_StockTake_WarehouseID] DEFAULT ([Company].[f_WareHouseGetFirstID]()),
[Warehouse] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTake_Warehouse] DEFAULT ([Company].[f_WareHouseGetFirstName]()),
[ReasonStockAdjustmentID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_StockTake_ReasonStockAdjustmentID] DEFAULT ([Items].[f_ReasonStockAdjustmentGetFirstID]()),
[ReasonStockAdjustment] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTake_ReasonStockAdjustment] DEFAULT ([Items].[f_ReasonStockAdjustmentGetFirstName]()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_StockTake_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTake_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_StockTake_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTake_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_StockTake_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_StockTake_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_StockTake_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[NetIs] [float] NOT NULL CONSTRAINT [DF_t_StockTake_NetIs] DEFAULT ((0)),
[NetIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTake_NetIsF] DEFAULT ('0'),
[NetIsD] [float] NOT NULL CONSTRAINT [DF_t_StockTake_NetIsD] DEFAULT ((0)),
[NetIsLL] [float] NOT NULL CONSTRAINT [DF_t_StockTake_NetIsLL] DEFAULT ((0)),
[NetIsEuro] [float] NOT NULL CONSTRAINT [DF_t_StockTake_NetIsEuro] DEFAULT ((0)),
[NetIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTake_NetIsAR] DEFAULT (''),
[NetIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTake_NetIsEN] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_StockTake_Qtys] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTake_DescriptionIs] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_StockTake_ItemsNames] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_StockTake_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_StockTake_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_StockTake]
ON [Items].[t_StockTake]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, StockTake, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Items].[t_StockTake] ADD CONSTRAINT [PK_t_StockTake] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_StockTake] ADD CONSTRAINT [CurrencyKeyStockTake] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Items].[t_StockTake] ADD CONSTRAINT [ReasonStockAdjustmentKeyStockTake] FOREIGN KEY ([ReasonStockAdjustmentID]) REFERENCES [Items].[t_ReasonStockAdjustment] ([ID])
GO
ALTER TABLE [Items].[t_StockTake] ADD CONSTRAINT [UserKeyStockTake] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'General = 0
SpecificDate = 1', 'SCHEMA', N'Items', 'TABLE', N't_StockTake', 'COLUMN', N'TypeIs'
GO
