CREATE TYPE [Company].[tt_SMSService] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[BatchID] [bigint] NOT NULL,
[DateSend] [datetime] NOT NULL,
[StatusIs] [tinyint] NOT NULL,
[SenderID] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[TotalMobiles] [int] NOT NULL,
[MessageIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[EventIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
