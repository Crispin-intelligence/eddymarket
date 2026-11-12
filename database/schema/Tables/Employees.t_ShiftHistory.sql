CREATE TABLE [Employees].[t_ShiftHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ShiftHistory_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_ShiftHistory_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_RefF] DEFAULT ('0'),
[EmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ShiftHistory_EmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[Employee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_Employee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_ShiftHistory_DateIs] DEFAULT (getdate()),
[FromIsMust] [datetime] NOT NULL CONSTRAINT [DF_t_ShiftHistory_FromIsMust] DEFAULT (getdate()),
[FromIs] [datetime] NULL,
[ShiftMinuteMust] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_ShiftMinuteMust] DEFAULT ((0)),
[ShiftHourMust] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_ShiftHourMust] DEFAULT ((0)),
[ShiftMustF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_ShiftMustF] DEFAULT ('0'),
[EarlyMinute] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_EarlyMinute] DEFAULT ((0)),
[EarlyF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_EarlyF] DEFAULT ('0'),
[CalculationEarly] [bit] NOT NULL CONSTRAINT [DF_t_ShiftHistory_CalculationEarly] DEFAULT ((0)),
[LateMinute] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_LateMinute] DEFAULT ((0)),
[LateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_LateF] DEFAULT ('0'),
[LateX] [decimal] (2, 1) NOT NULL CONSTRAINT [DF_t_ShiftHistory_LateX] DEFAULT ((1)),
[LateMinuteNet] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_LateMinuteNet] DEFAULT ((0)),
[LateNetF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_LateNetF] DEFAULT ('0'),
[LateMinuteExtra] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_LateMinuteExtra] DEFAULT ((0)),
[LateExtraF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_LateExtraF] DEFAULT ('0'),
[ToIsMust] [datetime] NOT NULL CONSTRAINT [DF_t_ShiftHistory_ToIsMust] DEFAULT (getdate()),
[ToIs] [datetime] NULL,
[ShiftMinute] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_ShiftMinute] DEFAULT ((0)),
[ShiftHour] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_ShiftHour] DEFAULT ((0)),
[ShiftF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_ShiftF] DEFAULT ('0'),
[OverTimeMinute] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_OverTimeMinute] DEFAULT ((0)),
[OverTimeF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_OverTimeF] DEFAULT ('0'),
[CalculationOverTime] [bit] NOT NULL CONSTRAINT [DF_t_ShiftHistory_CalculationOverTime] DEFAULT ((0)),
[OverTimeX] [decimal] (2, 1) NOT NULL CONSTRAINT [DF_t_ShiftHistory_OverTimeX] DEFAULT ((1)),
[OverTimeMinuteNet] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_OverTimeMinuteNet] DEFAULT ((0)),
[OverTimeNetF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_OverTimeNetF] DEFAULT ('0'),
[OverTimeMinuteExtra] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_OverTimeMinuteExtra] DEFAULT ((0)),
[OverTimeExtraF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_OverTimeExtraF] DEFAULT ('0'),
[ShiftMinuteNet] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_ShiftMinuteNet] DEFAULT ((0)),
[ShiftHourNet] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_ShiftHourNet] DEFAULT ((0)),
[ShiftNetF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_ShiftNetF] DEFAULT ('0'),
[TimeIncompleteMinute] [float] NOT NULL CONSTRAINT [DF_t_ShiftHistory_TimeIncompleteMinute] DEFAULT ((0)),
[TimeIncompleteF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_TimeIncompleteF] DEFAULT ('0'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ShiftHistory_DescriptionIs] DEFAULT (''),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_ShiftHistory_StatusIs] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ShiftHistory_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ShiftHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_ShiftHistory]
ON [Employees].[t_ShiftHistory]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, EmployeeInOut, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Employees].[t_ShiftHistory] ADD CONSTRAINT [PK_t_ShiftHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_ShiftHistory_Ref] ON [Employees].[t_ShiftHistory] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_ShiftHistory] ADD CONSTRAINT [EmployeeKeyShiftHistory] FOREIGN KEY ([EmployeeID]) REFERENCES [Employees].[t_Employee] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal = 0
Calculated = 1
Canceled = 2', 'SCHEMA', N'Employees', 'TABLE', N't_ShiftHistory', 'COLUMN', N'StatusIs'
GO
