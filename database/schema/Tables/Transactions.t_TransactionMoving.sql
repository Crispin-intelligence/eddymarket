CREATE TABLE [Transactions].[t_TransactionMoving]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransactionMoving_ID] DEFAULT (newsequentialid()),
[UserID] [uniqueidentifier] NOT NULL,
[SectionID] [uniqueidentifier] NOT NULL,
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_TransactionMoving_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_TransactionMoving_DateOnly] DEFAULT (getdate()),
[EventIs] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[EventType] [tinyint] NOT NULL,
[ComputerIP] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[Computer] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[ComputerAccount] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_TransactionMoving_WorkStationID] DEFAULT ((1))
) ON [Transactions]
GO
ALTER TABLE [Transactions].[t_TransactionMoving] ADD CONSTRAINT [PK_t_TransactionMoving] PRIMARY KEY CLUSTERED  ([ID]) ON [Transactions]
GO
CREATE NONCLUSTERED INDEX [IX_t_TransactionMovingDateIs] ON [Transactions].[t_TransactionMoving] ([DateIs]) ON [PRIMARY]
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
11 = Delete From The App', 'SCHEMA', N'Transactions', 'TABLE', N't_TransactionMoving', 'COLUMN', N'EventType'
GO
