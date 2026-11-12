CREATE TABLE [Users].[t_UserNotifications]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_UserNotifications_ID] DEFAULT (newsequentialid()),
[NotificationID] [bigint] NOT NULL IDENTITY(1, 1),
[NotificationType] [smallint] NOT NULL,
[NotificationSectionID] [bigint] NOT NULL,
[NotificationText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[NotificationFromUserID] [int] NOT NULL,
[NotificationToUserID] [int] NOT NULL,
[NotificationDateSend] [datetime] NOT NULL CONSTRAINT [DF_UserNotifications_NotificationDateSend] DEFAULT (getdate()),
[NotificationDateSee] [datetime] NULL,
[NotificationStop] [bit] NOT NULL CONSTRAINT [DF_t_UserNotifications_NotificationStop] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_UserNotifications_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Users].[t_UserNotifications] ADD CONSTRAINT [PK_t_UserNotifications] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_NotificationFromUserID] ON [Users].[t_UserNotifications] ([NotificationFromUserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_NotificationToUserID] ON [Users].[t_UserNotifications] ([NotificationToUserID]) ON [PRIMARY]
GO
