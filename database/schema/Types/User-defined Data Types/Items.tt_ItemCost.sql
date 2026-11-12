CREATE TYPE [Items].[tt_ItemCost] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[Purchase] [float] NOT NULL,
[EventIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
