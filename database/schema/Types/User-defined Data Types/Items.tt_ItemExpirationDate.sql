CREATE TYPE [Items].[tt_ItemExpirationDate] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[WareHouseID] [uniqueidentifier] NOT NULL,
[Qtys] [decimal] (18, 4) NOT NULL,
[ProductionDate] [date] NOT NULL,
[ExpirationDate] [date] NOT NULL,
[NotifyMeDaysBefore] [int] NOT NULL,
[CurrencyID] [uniqueidentifier] NOT NULL,
[Price] [float] NOT NULL,
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
