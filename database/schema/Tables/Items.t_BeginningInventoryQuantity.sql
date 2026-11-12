CREATE TABLE [Items].[t_BeginningInventoryQuantity]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_RefF] DEFAULT ('0'),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_DateIs] DEFAULT (getdate()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[Total] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_TotalEuro] DEFAULT ((0)),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_Qtys] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_DescriptionIs] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_ItemsNames] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantity_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_BeginningInventoryQuantity]
ON [Items].[t_BeginningInventoryQuantity]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(
                                   VersionLive,
                                   BeginningInventoryQuantity,
                                   3,
                                   FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')
                               ),
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Items].[t_BeginningInventoryQuantity] ADD CONSTRAINT [PK_t_BeginningInventoryQuantity] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_BeginningInventoryQuantity] ADD CONSTRAINT [CurrencyKeyBeginningInventoryQuantity] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
