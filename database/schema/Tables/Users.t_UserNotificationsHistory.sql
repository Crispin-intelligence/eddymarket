CREATE TABLE [Users].[t_UserNotificationsHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_UserNotificationsHistory_ID] DEFAULT (newsequentialid()),
[NotificationID] [bigint] NOT NULL,
[NotificationType] [smallint] NOT NULL,
[NotificationSectionID] [bigint] NOT NULL,
[NotificationText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[NotificationFromUserID] [int] NOT NULL,
[NotificationToUserID] [int] NOT NULL,
[NotificationDateSend] [datetime] NOT NULL,
[NotificationDateSee] [datetime] NOT NULL,
[NotificationStop] [bit] NOT NULL,
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_UserNotificationsHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Users].[t_UserNotificationsHistory] ADD CONSTRAINT [PK_t_UserNotificationsHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
