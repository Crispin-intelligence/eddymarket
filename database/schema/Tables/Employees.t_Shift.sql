CREATE TABLE [Employees].[t_Shift]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Shift_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_Shift_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_RefF] DEFAULT ('0'),
[EmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Shift_EmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[Employee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_Employee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_Shift_DateIs] DEFAULT (getdate()),
[FromIsMust] [datetime] NOT NULL CONSTRAINT [DF_t_Shift_FromIsMust] DEFAULT (getdate()),
[FromIs] [datetime] NULL,
[ShiftMinuteMust] [float] NOT NULL CONSTRAINT [DF_t_Shift_ShiftMinuteMust] DEFAULT ((0)),
[ShiftHourMust] [float] NOT NULL CONSTRAINT [DF_t_Shift_ShiftHourMust] DEFAULT ((0)),
[ShiftMustF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_ShiftMustF] DEFAULT ('0'),
[EarlyMinute] [float] NOT NULL CONSTRAINT [DF_t_Shift_EarlyMinute] DEFAULT ((0)),
[EarlyF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_EarlyF] DEFAULT ('0'),
[CalculationEarly] [bit] NOT NULL CONSTRAINT [DF_t_Shift_CalculationEarly] DEFAULT ((0)),
[LateMinute] [float] NOT NULL CONSTRAINT [DF_t_Shift_LateMinute] DEFAULT ((0)),
[LateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_LateF] DEFAULT ('0'),
[LateX] [decimal] (2, 1) NOT NULL CONSTRAINT [DF_t_Shift_LateX] DEFAULT ((1)),
[LateMinuteNet] [float] NOT NULL CONSTRAINT [DF_t_Shift_LateMinuteNet] DEFAULT ((0)),
[LateNetF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_LateNetF] DEFAULT ('0'),
[LateMinuteExtra] [float] NOT NULL CONSTRAINT [DF_t_Shift_LateMinuteExtra] DEFAULT ((0)),
[LateExtraF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_LateExtraF] DEFAULT ('0'),
[ToIsMust] [datetime] NOT NULL CONSTRAINT [DF_t_Shift_ToIsMust] DEFAULT (getdate()),
[ToIs] [datetime] NULL,
[ShiftMinute] [float] NOT NULL CONSTRAINT [DF_t_Shift_ShiftMinute] DEFAULT ((0)),
[ShiftHour] [float] NOT NULL CONSTRAINT [DF_t_Shift_ShiftHour] DEFAULT ((0)),
[ShiftF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_ShiftF] DEFAULT ('0'),
[OverTimeMinute] [float] NOT NULL CONSTRAINT [DF_t_Shift_OverTimeIs] DEFAULT ((0)),
[OverTimeF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_OverTimeF] DEFAULT ('0'),
[CalculationOverTime] [bit] NOT NULL CONSTRAINT [DF_t_Shift_CalculationOverTime] DEFAULT ((0)),
[OverTimeX] [decimal] (2, 1) NOT NULL CONSTRAINT [DF_t_Shift_OverTimeX] DEFAULT ((1)),
[OverTimeMinuteNet] [float] NOT NULL CONSTRAINT [DF_t_Shift_OverTimeMinuteNet] DEFAULT ((0)),
[OverTimeNetF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_OverTimeNetF] DEFAULT ('0'),
[OverTimeMinuteExtra] [float] NOT NULL CONSTRAINT [DF_t_Shift_OverTimeMinuteExtra] DEFAULT ((0)),
[OverTimeExtraF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_OverTimeExtraF] DEFAULT ('0'),
[ShiftMinuteNet] [float] NOT NULL CONSTRAINT [DF_t_Shift_ShiftMinuteNet] DEFAULT ((0)),
[ShiftHourNet] [float] NOT NULL CONSTRAINT [DF_t_Shift_ShiftHourNet] DEFAULT ((0)),
[ShiftNetF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_ShiftNetF] DEFAULT ('0'),
[TimeIncompleteMinute] [float] NOT NULL CONSTRAINT [DF_t_Shift_TimeIncompleteMinute] DEFAULT ((0)),
[TimeIncompleteF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_TimeIncompleteF] DEFAULT ('0'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Shift_DescriptionIs] DEFAULT (''),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Shift_StatusIs] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Shift_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Shift_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_Shift]
ON [Employees].[t_Shift]
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
ALTER TABLE [Employees].[t_Shift] ADD CONSTRAINT [PK_t_Shift] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Shift_Ref] ON [Employees].[t_Shift] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_Shift] ADD CONSTRAINT [EmployeeKeyShift] FOREIGN KEY ([EmployeeID]) REFERENCES [Employees].[t_Employee] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal = 0
Calculated = 1
Canceled = 2', 'SCHEMA', N'Employees', 'TABLE', N't_Shift', 'COLUMN', N'StatusIs'
GO
