CREATE TABLE [Gym].[t_GymMemberAttendanceMoving]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymMemberAttendanceMoving_ID] DEFAULT (newsequentialid()),
[UserID] [uniqueidentifier] NOT NULL,
[SectionID] [uniqueidentifier] NOT NULL,
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_GymMemberAttendanceMoving_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_GymMemberAttendanceMoving_DateOnly] DEFAULT (getdate()),
[EventIs] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[EventType] [tinyint] NOT NULL,
[ComputerIP] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[Computer] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[ComputerAccount] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_GymMemberAttendanceMoving_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Gym].[t_GymMemberAttendanceMoving] ADD CONSTRAINT [PK_t_GymMemberAttendanceMoving] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Gym].[t_GymMemberAttendanceMoving] ADD CONSTRAINT [UserKeyGymMemberAttendanceMoving] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Insert
1 = Edit
2 = Delete
3 = Report
4 = Delete Tracking
5 = Login
6 = Rebuilding Statistics
7 = Upload Online
8 = Upload Image Online
9 = Insert From The App
10 = Edit From The App
11 = Delete From The App', 'SCHEMA', N'Gym', 'TABLE', N't_GymMemberAttendanceMoving', 'COLUMN', N'EventType'
GO
