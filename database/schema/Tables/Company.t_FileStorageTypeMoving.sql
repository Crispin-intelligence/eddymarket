CREATE TABLE [Company].[t_FileStorageTypeMoving]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FileStorageTypeMoving_ID] DEFAULT (newsequentialid()),
[UserID] [uniqueidentifier] NOT NULL,
[SectionID] [uniqueidentifier] NOT NULL,
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_FileStorageTypeMoving_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_FileStorageTypeMoving_DateOnly] DEFAULT (getdate()),
[EventIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[EventType] [tinyint] NOT NULL,
[ComputerIP] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[Computer] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[ComputerAccount] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_FileStorageTypeMoving_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Company].[t_FileStorageTypeMoving] ADD CONSTRAINT [PK_t_FileStorageTypeMoving] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_FileStorageTypeMovingComputer] ON [Company].[t_FileStorageTypeMoving] ([Computer]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_FileStorageTypeMovingComputerAccount] ON [Company].[t_FileStorageTypeMoving] ([ComputerAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_FileStorageTypeMovingComputerIP] ON [Company].[t_FileStorageTypeMoving] ([ComputerIP]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_FileStorageTypeMovingSectionID] ON [Company].[t_FileStorageTypeMoving] ([SectionID]) ON [PRIMARY]
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
11 = Delete From The App', 'SCHEMA', N'Company', 'TABLE', N't_FileStorageTypeMoving', 'COLUMN', N'EventType'
GO
