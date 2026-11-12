CREATE TYPE [Cars].[tt_CarRentalOwner] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[OwnerProfileID] [uniqueidentifier] NOT NULL,
[ProfitRatio] [decimal] (5, 2) NOT NULL,
[Profit] [float] NOT NULL
)
GO
