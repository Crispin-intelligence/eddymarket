CREATE TYPE [Employees].[tt_Shift] AS TABLE
(
[EmployeeID] [uniqueidentifier] NOT NULL,
[FromIsMust] [datetime] NOT NULL,
[CalculationEarly] [bit] NOT NULL,
[LateX] [decimal] (2, 1) NOT NULL,
[ToIsMust] [datetime] NOT NULL,
[CalculationOverTime] [bit] NOT NULL,
[OverTimeX] [decimal] (2, 1) NOT NULL
)
GO
