CREATE TABLE [Company].[t_SMSService]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SMSService_ID] DEFAULT (newsequentialid()),
[BatchID] [bigint] NOT NULL CONSTRAINT [DF_t_SMSService_BatchID] DEFAULT ((0)),
[DateSend] [datetime] NOT NULL CONSTRAINT [DF_t_SMSService_DateSend] DEFAULT (getdate()),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_SMSService_StatusIs] DEFAULT ((1)),
[SenderID] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SMSService_SenderID] DEFAULT (''),
[TotalMobiles] [int] NOT NULL CONSTRAINT [DF_t_SMSService_TotalMobiles] DEFAULT ((0)),
[MessageIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SMSService_MessageIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SMSService_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SMSService_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_SMSService] ON [Company].[t_SMSService]
    AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE  Alls.t_LiveVersion
        SET     VersionLive = STUFF(VersionLive, SMSService, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
                SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;

GO
ALTER TABLE [Company].[t_SMSService] ADD CONSTRAINT [PK_t_SMSService] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_SMSService] ADD CONSTRAINT [ui_t_SMSService_BatchID] UNIQUE NONCLUSTERED  ([BatchID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_SMSService] ADD CONSTRAINT [FK_t_SMSService_t_SMSService] FOREIGN KEY ([ID]) REFERENCES [Company].[t_SMSService] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pending = 1
Sent = 2
Error = 12
Processing = 14', 'SCHEMA', N'Company', 'TABLE', N't_SMSService', 'COLUMN', N'StatusIs'
GO
