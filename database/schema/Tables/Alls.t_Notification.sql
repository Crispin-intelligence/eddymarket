CREATE TABLE [Alls].[t_Notification]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Notification_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_Notification_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Notification_RefF] DEFAULT ('0'),
[TextIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Notification_TextIs] DEFAULT (''),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_Notification_DateIs] DEFAULT (getdate()),
[IsStop] [bit] NOT NULL CONSTRAINT [DF_t_Notification_IsStop] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Notification_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Notification_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Alls].[tr_Notification]
ON [Alls].[t_Notification]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, SystemNotification, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaAll, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;
	
END;
GO
ALTER TABLE [Alls].[t_Notification] ADD CONSTRAINT [PK_t_Notification] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_Notification_DateIs] ON [Alls].[t_Notification] ([DateIs]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_Notification_IsStop] ON [Alls].[t_Notification] ([IsStop]) ON [PRIMARY]
GO
