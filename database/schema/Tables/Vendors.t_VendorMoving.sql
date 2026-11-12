CREATE TABLE [Vendors].[t_VendorMoving]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_VendorMoving_ID] DEFAULT (newsequentialid()),
[UserID] [uniqueidentifier] NOT NULL,
[SectionID] [uniqueidentifier] NOT NULL,
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_VendorMoving_VendorMovingDate] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_VendorMoving_DateOnly] DEFAULT (getdate()),
[EventIs] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[EventType] [tinyint] NOT NULL,
[ComputerIP] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[Computer] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[ComputerAccount] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_VendorsMoving_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Vendors].[t_VendorMoving] ADD CONSTRAINT [PK_t_VendorMoving] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_trg_VendorsDate] ON [Vendors].[t_VendorMoving] ([DateIs]) ON [PRIMARY]
GO
ALTER TABLE [Vendors].[t_VendorMoving] ADD CONSTRAINT [UserKeyVendorMoving] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID]) ON DELETE CASCADE
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
11 = Delete From The App', 'SCHEMA', N'Vendors', 'TABLE', N't_VendorMoving', 'COLUMN', N'EventType'
GO
