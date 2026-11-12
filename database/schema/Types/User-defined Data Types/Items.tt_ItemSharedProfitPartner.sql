CREATE TYPE [Items].[tt_ItemSharedProfitPartner] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ProfitRatio] [decimal] (5, 2) NOT NULL,
[EventIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
