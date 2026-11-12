CREATE TYPE [Requests].[dt_RequestSchedule] AS TABLE
(
[ID] [bigint] NULL,
[EmployeeID] [int] NULL,
[TakeIn] [datetime] NULL,
[Appointment] [datetime] NULL,
[NoteIs] [nvarchar] (max) COLLATE Arabic_CI_AS NULL
)
GO
