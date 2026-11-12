CREATE TABLE [Users].[t_ChatHistory]
(
[ID] [uniqueidentifier] NOT NULL,
[FromUserID] [int] NOT NULL CONSTRAINT [DF_t_ChatHistory_UserSendID] DEFAULT ((1)),
[ToUserID] [int] NOT NULL CONSTRAINT [DF_t_ChatHistory_ToUserID] DEFAULT ((2)),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_ChatHistory_TypeIs] DEFAULT ((0)),
[TextIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChatHistory_TextIs] DEFAULT (''),
[DataIs] [varbinary] (max) NULL,
[SendIn] [datetime] NOT NULL CONSTRAINT [DF_t_ChatHistory_SendIn] DEFAULT (getdate()),
[ReadIn] [datetime] NULL,
[FromIsDeleted] [bit] NOT NULL CONSTRAINT [DF_t_ChatHistory_FromIsDeleted] DEFAULT ((0)),
[ToIsDeleted] [bit] NOT NULL CONSTRAINT [DF_t_ChatHistory_ToIsDeleted] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ChatHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
