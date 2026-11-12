CREATE TYPE [Invoices].[tt_SoldDetailProfitPartner] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[SoldDetailID] [uniqueidentifier] NOT NULL,
[ProfitPartnerID] [uniqueidentifier] NOT NULL,
[ProfitRatio] [decimal] (5, 2) NOT NULL,
[Profit] [float] NOT NULL
)
GO
