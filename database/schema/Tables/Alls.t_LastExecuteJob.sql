CREATE TABLE [Alls].[t_LastExecuteJob]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_LastExecuteJob_ID] DEFAULT (newsequentialid()),
[Company_Account_StatusIs] [date] NOT NULL CONSTRAINT [DF_t_LastExecuteJob_Company_Account_StatusIs] DEFAULT (getdate()),
[Company_Contact_AgeIs] [date] NOT NULL CONSTRAINT [DF_t_LastExecuteJob_Company_Contact_AgeIs] DEFAULT (getdate()),
[Employees_Employee_AgeIs] [date] NOT NULL CONSTRAINT [DF_t_LastExecuteJob_Employees_Employee_AgeIs] DEFAULT (getdate()),
[Items_ItemShared_StatusIs] [date] NOT NULL CONSTRAINT [DF_t_LastExecuteJob_Items_ItemShared_StatusIs] DEFAULT (getdate()),
[Customers_t_Customer] [date] NOT NULL CONSTRAINT [DF_t_LastExecuteJob_Customers_t_Customer] DEFAULT (getdate()),
[Company_Doctor_AgeIs] [date] NOT NULL CONSTRAINT [DF_t_LastExecuteJob_Company_Doctor_AgeIs] DEFAULT (getdate()),
[Gym_GymSubscription] [date] NOT NULL CONSTRAINT [DF_t_LastExecuteJob_Gym_GymSubscription] DEFAULT (getdate()),
[Cars_CarDriver] [date] NOT NULL CONSTRAINT [DF_t_LastExecuteJob_Cars_CarDriver] DEFAULT (getdate()),
[Cars_Car] [date] NOT NULL CONSTRAINT [DF_t_LastExecuteJob_Cars_Car] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [Alls].[t_LastExecuteJob] ADD CONSTRAINT [PK_t_LastExecuteJob] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
