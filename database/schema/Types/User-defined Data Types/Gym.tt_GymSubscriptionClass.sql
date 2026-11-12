CREATE TYPE [Gym].[tt_GymSubscriptionClass] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[ClassID] [uniqueidentifier] NOT NULL,
[AccountEmployeeID] [uniqueidentifier] NOT NULL,
[Price] [float] NOT NULL,
[SalaryPercent] [decimal] (5, 2) NOT NULL,
[Salary] [float] NOT NULL,
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
