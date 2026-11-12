CREATE TABLE [Company].[t_PlaceMoving]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PlaceMoving_ID] DEFAULT (newsequentialid()),
[UserID] [uniqueidentifier] NOT NULL,
[SectionID] [uniqueidentifier] NOT NULL,
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_PlaceMoving_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_PlaceMoving_DateOnly] DEFAULT (getdate()),
[EventIs] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PlaceMoving_EventIs] DEFAULT (''),
[EventType] [tinyint] NOT NULL CONSTRAINT [DF_t_PlaceMoving_EventType] DEFAULT ((0)),
[ComputerIP] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PlaceMoving_ComputerIP] DEFAULT (''),
[Computer] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PlaceMoving_Computer] DEFAULT (''),
[ComputerAccount] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PlaceMoving_ComputerAccount] DEFAULT (''),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_PlaceMoving_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_PlaceMoving] ADD CONSTRAINT [PK_t_PlaceMoving] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_PlaceMoving_Date] ON [Company].[t_PlaceMoving] ([DateIs]) ON [PRIMARY]
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
11 = Delete From The App', 'SCHEMA', N'Company', 'TABLE', N't_PlaceMoving', 'COLUMN', N'EventType'
GO
