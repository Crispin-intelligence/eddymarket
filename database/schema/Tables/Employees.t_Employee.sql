CREATE TABLE [Employees].[t_Employee]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Employee_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_Name] DEFAULT (N'الموظف العام'),
[Phones] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_Phones] DEFAULT (''),
[PhonesC] [int] NOT NULL CONSTRAINT [DF_t_Employee_PhonesC] DEFAULT ((0)),
[SocialMedia] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_SocialMedia] DEFAULT (''),
[SocialMediaC] [int] NOT NULL CONSTRAINT [DF_t_Employee_SocialMediaC] DEFAULT ((0)),
[TypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Employee_TypeID] DEFAULT ([Employees].[f_EmployeeTypeGetFirstID]()),
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_TypeIs] DEFAULT ([Employees].[f_EmployeeTypeGetFirstName]()),
[Gender] [tinyint] NOT NULL CONSTRAINT [DF_t_Employee_Gender] DEFAULT ((0)),
[NationalityID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Employee_NationalityID] DEFAULT ([Employees].[f_NationalityGetFirstID]()),
[Nationality] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_Nationality] DEFAULT ([Employees].[f_NationalityGetFirstName]()),
[Birthday] [date] NOT NULL CONSTRAINT [DF_t_Employee_Birthday] DEFAULT (getdate()),
[AgeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_AgeIs] DEFAULT (''),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Employee_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[RegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Employee_RegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[RegionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_RegionIs] DEFAULT ([Location].[f_RegionGetFirstName]()),
[StreetID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Employee_StreetID] DEFAULT ([Location].[f_StreetGetFirstID]()),
[Street] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_Street] DEFAULT ([Location].[f_StreetGetFirstName]()),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Employee_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[FloorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Employee_FloorID] DEFAULT ([Location].[f_FloorGetFirstID]()),
[FloorIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_FloorIs] DEFAULT ([Location].[f_FloorGetFirstName]()),
[PostalCodeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Employee_PostalCodeID] DEFAULT ([Location].[f_PostalCodeGetFirstID]()),
[PostalCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_PostalCode] DEFAULT ([Location].[f_PostalCodeGetFirstName]()),
[AddressNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_AddressNote] DEFAULT (''),
[AddressIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_AddressIs] DEFAULT (''),
[DateWork] [date] NOT NULL CONSTRAINT [DF_t_Employee_DateWork] DEFAULT (getdate()),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_DescriptionIs] DEFAULT (''),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_Employee_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImagePath] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_ImagePath] DEFAULT (''),
[ImageID] [image] NOT NULL CONSTRAINT [DF_t_Employee_ImageID] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImagePathID] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_ImagePathID] DEFAULT (''),
[IDFingerPrint] [int] NOT NULL CONSTRAINT [DF_t_Employee_IDFingerPrint] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Employee_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[SalaryIs] [float] NOT NULL CONSTRAINT [DF_t_Employee_SalaryIs] DEFAULT ((0)),
[SalaryIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_SalaryIsF] DEFAULT (''),
[SalaryDeliveryService] [float] NOT NULL CONSTRAINT [DF_t_Employee_SalaryDeliveryService] DEFAULT ((0)),
[SalaryDeliveryServiceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_SalaryDeliveryServiceF] DEFAULT ('0'),
[DaysWork] [int] NOT NULL CONSTRAINT [DF_t_Employee_DaysWork] DEFAULT ((26)),
[DaysWorkHours] [int] NOT NULL CONSTRAINT [DF_t_Employee_DaysWorkHours] DEFAULT ((8)),
[TotalHoursFree] [int] NOT NULL CONSTRAINT [DF_t_Employee_TotalHoursFree] DEFAULT ((0)),
[TotalHoursMustWork] [int] NOT NULL CONSTRAINT [DF_t_Employee_TotalHoursMustWork] DEFAULT ((234)),
[SalaryHours] [float] NOT NULL CONSTRAINT [DF_t_Employee_SalaryHours] DEFAULT ((0)),
[SalaryHoursF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_SalaryHoursF] DEFAULT (''),
[VacationDay] [tinyint] NOT NULL CONSTRAINT [DF_t_Employee_VacationDay] DEFAULT ((0)),
[HoursLateX] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_Employee_HoursLateX] DEFAULT ((1)),
[HoursOverX] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_Employee_HoursOverX] DEFAULT ((1)),
[CalculationEarly] [bit] NOT NULL CONSTRAINT [DF_t_Employee_CalculationEarly] DEFAULT ((0)),
[CalculationOverTime] [bit] NOT NULL CONSTRAINT [DF_t_Employee_CalculationTime] DEFAULT ((1)),
[ShiftFrom] [time] NOT NULL CONSTRAINT [DF_t_Employee_ShiftFrom] DEFAULT (getdate()),
[ShiftTo] [time] NOT NULL CONSTRAINT [DF_t_Employee_ShiftTo] DEFAULT (getdate()),
[InWorkNow] [bit] NOT NULL CONSTRAINT [DF_t_Employee_InWorkNow] DEFAULT ((0)),
[VacationAvailableC] [int] NOT NULL CONSTRAINT [DF_t_Employee_VacationAvailableC] DEFAULT ((0)),
[TotalExitEntryPermission] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Employee_TotalExitEntryPermission] DEFAULT ((0)),
[DiscountAvailable] [float] NOT NULL CONSTRAINT [DF_t_Employee_DiscountAvailable] DEFAULT ((0)),
[DiscountAvailableF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_DiscountAvailableF] DEFAULT ('0'),
[BonusAvailable] [float] NOT NULL CONSTRAINT [DF_t_Employee_BonusAvailable] DEFAULT ((0)),
[BonusAvailableF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_BonusAvailableF] DEFAULT ('0'),
[RequestC] [bigint] NOT NULL CONSTRAINT [DF_t_Employee_RequestC] DEFAULT ((0)),
[FileStorageC] [bigint] NOT NULL CONSTRAINT [DF_t_Employee_FileStorageC] DEFAULT ((0)),
[FeedbackC] [bigint] NOT NULL CONSTRAINT [DF_t_Employee_FeedbackC] DEFAULT ((0)),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Employee_StatusIs] DEFAULT ((0)),
[WhyThisStatus] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_WhyThisStatus] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Employee_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Employee_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Employee_IsSync] DEFAULT ((0)),
[IsSyncImage] [bit] NOT NULL CONSTRAINT [DF_t_Employee_IsSyncImage] DEFAULT ((0)),
[IsSyncImageID] [bit] NOT NULL CONSTRAINT [DF_t_Employee_IsSyncImageID] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Employees_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_Employee] ON [Employees].[t_Employee]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Employees.t_Employee
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Employee.ID );

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            1 ,
            'employee'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            1 ,
            'employee'
    FROM    Inserted AS s;
       
    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            1 ,
            'employee_ID'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            1 ,
            'employee_ID'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Employee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Employees].[t_Employee] ADD CONSTRAINT [PK_t_Employee_1] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_t_EmployeeName] ON [Employees].[t_Employee] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_Employee] ADD CONSTRAINT [BuildingKeyEmployee] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Employees].[t_Employee] ADD CONSTRAINT [EmployeeTypeKeyEmployee] FOREIGN KEY ([TypeID]) REFERENCES [Employees].[t_EmployeeType] ([ID])
GO
ALTER TABLE [Employees].[t_Employee] ADD CONSTRAINT [FloorKeyEmployee] FOREIGN KEY ([FloorID]) REFERENCES [Location].[t_Floor] ([ID])
GO
ALTER TABLE [Employees].[t_Employee] ADD CONSTRAINT [NationalityKeyEmployee] FOREIGN KEY ([NationalityID]) REFERENCES [Employees].[t_Nationality] ([ID])
GO
ALTER TABLE [Employees].[t_Employee] ADD CONSTRAINT [PostalCodeKeyEmployee] FOREIGN KEY ([PostalCodeID]) REFERENCES [Location].[t_PostalCode] ([ID])
GO
ALTER TABLE [Employees].[t_Employee] ADD CONSTRAINT [RegionkeyEmployee] FOREIGN KEY ([RegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Employees].[t_Employee] ADD CONSTRAINT [StatesKeyEmployee] FOREIGN KEY ([StatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Employees].[t_Employee] ADD CONSTRAINT [StreetKeyEmployee] FOREIGN KEY ([StreetID]) REFERENCES [Location].[t_Street] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group of columns TotalInvoices this is for delivery invoices', 'SCHEMA', N'Employees', 'TABLE', N't_Employee', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'male = 0
female = 1
unknown = 2', 'SCHEMA', N'Employees', 'TABLE', N't_Employee', 'COLUMN', N'Gender'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active = 0
Inactive = 1
Blocked = 2', 'SCHEMA', N'Employees', 'TABLE', N't_Employee', 'COLUMN', N'StatusIs'
GO
