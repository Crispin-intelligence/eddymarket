CREATE TYPE [Cars].[tt_CarOwners] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[OwnerProfileID] [uniqueidentifier] NOT NULL,
[ProfitRatio] [decimal] (5, 2) NOT NULL
)
GO
