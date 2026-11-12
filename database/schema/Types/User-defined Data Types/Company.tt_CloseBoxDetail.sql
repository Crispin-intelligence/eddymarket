CREATE TYPE [Company].[tt_CloseBoxDetail] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[CurrencyID] [uniqueidentifier] NOT NULL,
[Price] [float] NOT NULL,
[Qty] [int] NOT NULL,
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
