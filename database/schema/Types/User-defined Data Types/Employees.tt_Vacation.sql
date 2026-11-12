CREATE TYPE [Employees].[tt_Vacation] AS TABLE
(
[DateIs] [date] NOT NULL,
[EmployeeID] [uniqueidentifier] NOT NULL,
[DaysIs] [int] NOT NULL
)
GO
