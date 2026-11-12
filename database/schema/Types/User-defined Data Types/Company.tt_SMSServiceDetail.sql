CREATE TYPE [Company].[tt_SMSServiceDetail] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[BatchID] [bigint] NOT NULL,
[Mobile] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[DateSend] [datetime] NOT NULL,
[DateDone] [datetime] NULL,
[StatusIs] [tinyint] NOT NULL
)
GO
