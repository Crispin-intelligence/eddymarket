CREATE TABLE [Users].[t_Chat]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Chat_ID] DEFAULT (newsequentialid()),
[FromUserID] [int] NOT NULL CONSTRAINT [DF_t_Chat_UserSendID] DEFAULT ((1)),
[ToUserID] [int] NOT NULL CONSTRAINT [DF_t_Chat_ToUserID] DEFAULT ((2)),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Chat_TypeIs] DEFAULT ((0)),
[TextIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Chat_TextIs] DEFAULT (''),
[DataIs] [varbinary] (max) NULL,
[SendIn] [datetime] NOT NULL CONSTRAINT [DF_t_Chat_SendIn] DEFAULT (getdate()),
[ReadIn] [datetime] NULL,
[FromIsDeleted] [bit] NOT NULL CONSTRAINT [DF_t_Chat_FromIsDeleted] DEFAULT ((0)),
[ToIsDeleted] [bit] NOT NULL CONSTRAINT [DF_t_Chat_ToIsDeleted] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Chat_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Users].[tr_Chat] ON [Users].[t_Chat]
    AFTER INSERT, UPDATE, DELETE
AS
    BEGIN

        UPDATE  Alls.t_LiveVersion
        SET     VersionLive = STUFF(VersionLive, UserChat, 3,
                                    FORMAT(DATEPART(MILLISECOND, GETDATE()),
                                           '000')) ,
                SchemasIs = STUFF(SchemasIs, SchemaUser, 3,
                                  FORMAT(DATEPART(MILLISECOND, GETDATE()),
                                         '000'));



    END;


GO
CREATE NONCLUSTERED INDEX [i_t_Chat_FromUserID] ON [Users].[t_Chat] ([FromUserID]) ON [PRIMARY]
GO
ALTER TABLE [Users].[t_Chat] ADD CONSTRAINT [inc_t_Chat_ID] UNIQUE CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_Chat_ReadIn] ON [Users].[t_Chat] ([ReadIn]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_Chat_ToUserID] ON [Users].[t_Chat] ([ToUserID]) ON [PRIMARY]
GO
