CREATE TABLE [Customers].[t_CustomerGroupMoving]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CustomerGroupMoving_ID] DEFAULT (newsequentialid()),
[UserID] [uniqueidentifier] NOT NULL,
[SectionID] [uniqueidentifier] NOT NULL,
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_CustomerGroupsMoving_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_CustomerGroupMoving_DateOnly] DEFAULT (getdate()),
[EventIs] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[EventType] [tinyint] NOT NULL,
[ComputerIP] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[Computer] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[ComputerAccount] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CustomerGroupsMoving_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Customers].[t_CustomerGroupMoving] ADD CONSTRAINT [PK_t_CustomerGroupMoving] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Customers].[t_CustomerGroupMoving] ADD CONSTRAINT [UserKeyCustomerGroupMoving] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID]) ON DELETE CASCADE
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
11 = Delete From The App', 'SCHEMA', N'Customers', 'TABLE', N't_CustomerGroupMoving', 'COLUMN', N'EventType'
GO
