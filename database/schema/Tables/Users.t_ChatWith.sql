CREATE TABLE [Users].[t_ChatWith]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ChatWith_ID] DEFAULT (newsequentialid()),
[UserID] [int] NOT NULL,
[ChatWithID] [int] NOT NULL,
[IsPin] [bit] NOT NULL CONSTRAINT [DF_t_ChatWith_IsPin] DEFAULT ((0)),
[IsUnread] [bit] NOT NULL CONSTRAINT [DF_t_ChatWith_IsUnread] DEFAULT ((0)),
[LastChat] [datetime] NULL,
[LastType] [tinyint] NOT NULL CONSTRAINT [DF_t_ChatWith_LastType] DEFAULT ((0)),
[LastText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChatWith_LastText] DEFAULT (''),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ChatWith_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Users].[tr_ChatWith] ON [Users].[t_ChatWith]
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
ALTER TABLE [Users].[t_ChatWith] ADD CONSTRAINT [cc_t_ChatWithUserNotCahtWith] CHECK (([ChatWithID]<>[UserID]))
GO
ALTER TABLE [Users].[t_ChatWith] ADD CONSTRAINT [PK_t_ChatWith] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_ChatWithUserIDAndChatWithID] ON [Users].[t_ChatWith] ([UserID], [ChatWithID]) ON [PRIMARY]
GO
