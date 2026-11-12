CREATE TYPE [Vendors].[tt_VendorSchedulePayment] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[DateIs] [date] NOT NULL,
[Payment] [float] NOT NULL,
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
