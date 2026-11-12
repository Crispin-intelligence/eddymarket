CREATE TABLE [Company].[t_FileStorageMoving]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FileStorageMoving_ID] DEFAULT (newsequentialid()),
[UserID] [uniqueidentifier] NOT NULL,
[SectionID] [uniqueidentifier] NOT NULL,
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_FileStorageMoving_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_FileStorageMoving_DateOnly] DEFAULT (getdate()),
[EventIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[EventType] [tinyint] NOT NULL,
[ComputerIP] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[Computer] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[ComputerAccount] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_FileStorageMoving_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Company].[t_FileStorageMoving] ADD CONSTRAINT [PK_t_FileStorageMoving] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_FileStorageMovingComputer] ON [Company].[t_FileStorageMoving] ([Computer]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_FileStorageMovingComputerAccount] ON [Company].[t_FileStorageMoving] ([ComputerAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_FileStorageMovingComputerIP] ON [Company].[t_FileStorageMoving] ([ComputerIP]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_FileStorageMovingSectionID] ON [Company].[t_FileStorageMoving] ([SectionID]) ON [PRIMARY]
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
11 = Delete From The App', 'SCHEMA', N'Company', 'TABLE', N't_FileStorageMoving', 'COLUMN', N'EventType'
GO
