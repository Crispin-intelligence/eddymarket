CREATE TYPE [Items].[tt_ItemSerial] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[FatherID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[SerialText] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL
)
GO
