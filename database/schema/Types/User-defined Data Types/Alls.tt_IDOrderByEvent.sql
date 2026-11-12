CREATE TYPE [Alls].[tt_IDOrderByEvent] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[OrderBy] [bigint] NOT NULL,
[EventIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
