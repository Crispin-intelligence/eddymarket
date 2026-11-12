CREATE TABLE [Items].[t_MainCategoryMoving]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_MainCategoryMoving_ID] DEFAULT (newsequentialid()),
[UserID] [uniqueidentifier] NOT NULL,
[SectionID] [uniqueidentifier] NOT NULL,
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_MainCategoryMoving_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_MainCategoryMoving_DateOnly] DEFAULT (getdate()),
[EventIs] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[EventType] [tinyint] NOT NULL,
[ComputerIP] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[Computer] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[ComputerAccount] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_MainCategoryMoving_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_MainCategoryMoving] ADD CONSTRAINT [PK_t_MainCategoryMoving] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_t_MainCategoryMovingDate] ON [Items].[t_MainCategoryMoving] ([DateIs]) ON [PRIMARY]
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
11 = Delete From The App', 'SCHEMA', N'Items', 'TABLE', N't_MainCategoryMoving', 'COLUMN', N'EventType'
GO
