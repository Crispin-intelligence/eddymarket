CREATE TABLE [Company].[t_AccountEmailMoving]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountEmailMoving_ID] DEFAULT (newsequentialid()),
[UserID] [uniqueidentifier] NOT NULL,
[SectionID] [uniqueidentifier] NOT NULL,
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_AccountEmailMoving_DateIs] DEFAULT (getdate()),
[EventIs] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[EventType] [tinyint] NOT NULL,
[ComputerIP] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[Computer] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[ComputerAccount] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_AccountEmailMoving_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_AccountEmailMoving] ADD CONSTRAINT [PK_t_AccountEmailMoving] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_AccountEmailMovingComputer] ON [Company].[t_AccountEmailMoving] ([Computer]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_AccountEmailMovingComputerAccount] ON [Company].[t_AccountEmailMoving] ([ComputerAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_AccountEmailMovingComputerIP] ON [Company].[t_AccountEmailMoving] ([ComputerIP]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_t_AccountEmailMoving] ON [Company].[t_AccountEmailMoving] ([DateIs]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_AccountEmailMovingSectionID] ON [Company].[t_AccountEmailMoving] ([SectionID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Insert
1 = Edit
2 = Delete
3 = Report
4 = Delete Tracking
5 = Login
6 = Rebuilding Statistics
7 = Upload Online
8 = Upload Image Online', 'SCHEMA', N'Company', 'TABLE', N't_AccountEmailMoving', 'COLUMN', N'EventType'
GO
