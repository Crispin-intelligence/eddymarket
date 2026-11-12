CREATE TABLE [Company].[t_SMSServiceDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SMSServiceDetail_ID] DEFAULT (newsequentialid()),
[BatchID] [bigint] NOT NULL CONSTRAINT [DF_t_SMSServiceDetail_BatchID] DEFAULT ((0)),
[Mobile] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SMSServiceDetail_Mobile] DEFAULT (''),
[DateSend] [datetime] NOT NULL CONSTRAINT [DF_t_SMSServiceDetail_DateSend] DEFAULT (getdate()),
[DateDone] [datetime] NULL,
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_SMSServiceDetail_StatusIs] DEFAULT ((22)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SMSServiceDetail_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SMSServiceDetail_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Company].[t_SMSServiceDetail] ADD CONSTRAINT [PK_t_SMSServiceDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_SMSServiceDetail] ADD CONSTRAINT [SMSServiceKeySMSService] FOREIGN KEY ([BatchID]) REFERENCES [Company].[t_SMSService] ([BatchID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Delivered = 20
Not Delivered = 21
Waiting Delivery Report = 22', 'SCHEMA', N'Company', 'TABLE', N't_SMSServiceDetail', 'COLUMN', N'StatusIs'
GO
