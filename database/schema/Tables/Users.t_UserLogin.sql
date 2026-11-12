CREATE TABLE [Users].[t_UserLogin]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_UserLogin_ID] DEFAULT (newsequentialid()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_UserLogin_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UserLogin_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_UserLogin_DateIs] DEFAULT (getdate()),
[StartTime] [datetime] NOT NULL CONSTRAINT [DF_t_UserLogin_StartTime] DEFAULT (getdate()),
[EndTime] [datetime] NOT NULL CONSTRAINT [DF_t_UserLogin_EndTime] DEFAULT (getdate()),
[WorkTime] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UserLogin_WorkTime] DEFAULT ('00:00:00'),
[HoursIs] [float] NOT NULL CONSTRAINT [DF_t_UserLogin_HoursIs] DEFAULT ((0)),
[ComputerIP] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[Computer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[ComputerAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[IsOnline] [bit] NOT NULL CONSTRAINT [DF_t_UserLogin_Online] DEFAULT ((1)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_UserLogin_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Users].[t_UserLogin] ADD CONSTRAINT [PK_t_UserLogin] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_UserLogin_DateIs] ON [Users].[t_UserLogin] ([DateIs]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_UserLogin_Online] ON [Users].[t_UserLogin] ([IsOnline]) ON [PRIMARY]
GO
ALTER TABLE [Users].[t_UserLogin] ADD CONSTRAINT [UserKeyUserLogin] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID]) ON DELETE CASCADE
GO
