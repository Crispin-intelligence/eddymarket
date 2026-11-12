CREATE TABLE [Cars].[t_Car]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Car_ID] DEFAULT (newsequentialid()),
[FullName] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_FullName] DEFAULT (''),
[VehicleIdentificationNumber] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_VehicleIdentificationNumber] DEFAULT ('-'),
[StockNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_StockNumber] DEFAULT (''),
[RegistrationNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_RegistrationNumber] DEFAULT (''),
[MakeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Car_MakeID] DEFAULT ([Cars].[f_CarMakeGetFirstID]()),
[Make] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_Make] DEFAULT ([Cars].[f_CarMakeGetFirstName]()),
[ModelID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Car_ModelID] DEFAULT ([Cars].[f_CarModelGetFirstID]()),
[Model] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_Model] DEFAULT ([Cars].[f_CarModelGetFirstName]()),
[YearIs] [date] NOT NULL CONSTRAINT [DF_t_Car_YearIs] DEFAULT (getdate()),
[Color] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_Color] DEFAULT (''),
[ClassID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Car_ClassID] DEFAULT ([Cars].[f_CarClassGetFirstID]()),
[ClassName] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_ClassName] DEFAULT ([Cars].[f_CarClassGetFirstName]()),
[MaximunWeight] [int] NOT NULL CONSTRAINT [DF_t_Car_MaximunWeight] DEFAULT ((0)),
[Transmission] [tinyint] NOT NULL CONSTRAINT [DF_t_Car_Transmission] DEFAULT ((0)),
[Engine] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_Engine] DEFAULT (''),
[FuelType] [tinyint] NOT NULL CONSTRAINT [DF_t_Car_FuelType] DEFAULT ((0)),
[Odometer] [int] NOT NULL CONSTRAINT [DF_t_Car_Odometer] DEFAULT ((0)),
[AvailabilityIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Car_AvailabilityIs] DEFAULT ((0)),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_Car_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImagePath] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_ImagePath] DEFAULT (''),
[DamagesImage] [image] NOT NULL CONSTRAINT [DF_t_Car_DamagesImage] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[DamagesImagePath] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_DamagesImagePath] DEFAULT (''),
[PurchaseDate] [date] NOT NULL CONSTRAINT [DF_t_Car_PurchaseDate] DEFAULT (getdate()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Car_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[PurchasePrice] [float] NOT NULL CONSTRAINT [DF_t_Car_PurchasePrice] DEFAULT ((0)),
[PurchasePriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_PurchasePriceF] DEFAULT ('0'),
[PurchasePriceD] [float] NOT NULL CONSTRAINT [DF_t_Car_PurchasePriceD] DEFAULT ((0)),
[PurchasePriceLL] [float] NOT NULL CONSTRAINT [DF_t_Car_PurchasePriceLL] DEFAULT ((0)),
[PurchasePriceEuro] [float] NOT NULL CONSTRAINT [DF_t_Car_PurchasePriceEuro] DEFAULT ((0)),
[SalePrice] [float] NOT NULL CONSTRAINT [DF_t_Car_SalePrice] DEFAULT ((0)),
[SalePriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_SalePriceF] DEFAULT ('0'),
[SalePriceD] [float] NOT NULL CONSTRAINT [DF_t_Car_SalePriceD] DEFAULT ((0)),
[SalePriceLL] [float] NOT NULL CONSTRAINT [DF_t_Car_SalePriceLL] DEFAULT ((0)),
[SalePriceEuro] [float] NOT NULL CONSTRAINT [DF_t_Car_SalePriceEuro] DEFAULT ((0)),
[DayPrice] [float] NOT NULL CONSTRAINT [DF_t_Car_DayPrice] DEFAULT ((0)),
[DayPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_DayPriceF] DEFAULT ('0'),
[DayPriceD] [float] NOT NULL CONSTRAINT [DF_t_Car_DayPriceD] DEFAULT ((0)),
[DayPriceLL] [float] NOT NULL CONSTRAINT [DF_t_Car_DayPriceLL] DEFAULT ((0)),
[DayPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_Car_DayPriceEuro] DEFAULT ((0)),
[WeekPrice] [float] NOT NULL CONSTRAINT [DF_t_Car_WeekPrice] DEFAULT ((0)),
[WeekPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_WeekPriceF] DEFAULT ('0'),
[WeekPriceD] [float] NOT NULL CONSTRAINT [DF_t_Car_WeekPriceD] DEFAULT ((0)),
[WeekPriceLL] [float] NOT NULL CONSTRAINT [DF_t_Car_WeekPriceLL] DEFAULT ((0)),
[WeekPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_Car_WeekPriceEuro] DEFAULT ((0)),
[MonthPrice] [float] NOT NULL CONSTRAINT [DF_t_Car_MonthPrice] DEFAULT ((0)),
[MonthPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_MonthPriceF] DEFAULT ('0'),
[MonthPriceD] [float] NOT NULL CONSTRAINT [DF_t_Car_MonthPriceD] DEFAULT ((0)),
[MonthPriceLL] [float] NOT NULL CONSTRAINT [DF_t_Car_MonthPriceLL] DEFAULT ((0)),
[MonthPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_Car_MonthPriceEuro] DEFAULT ((0)),
[OfficeRatio] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_Car_OfficeRatio] DEFAULT ((25)),
[CarFor] [tinyint] NOT NULL CONSTRAINT [DF_t_Car_CarFor] DEFAULT ((0)),
[InsuranceIsActive] [bit] NOT NULL CONSTRAINT [DF_t_Car_InsuranceIsActive] DEFAULT ((1)),
[InsuranceCompany] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_InsuranceCompany] DEFAULT (''),
[InsuranceType] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_InsuranceType] DEFAULT (''),
[InsuranceDate] [date] NOT NULL CONSTRAINT [DF_t_Car_InsuranceDate] DEFAULT (getdate()),
[InsuranceActiveTo] [date] NOT NULL CONSTRAINT [DF_t_Car_InsuranceActiveTo] DEFAULT (getdate()),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_DescriptionIs] DEFAULT (''),
[Notes] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_Notes] DEFAULT (''),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Car_StatusIs] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Car_DateCreate] DEFAULT (getdate()),
[CarOwnersCount] [int] NOT NULL CONSTRAINT [DF_t_Car_CarOwnersCount] DEFAULT ((0)),
[CarOwners] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Car_CarOwners] DEFAULT (''),
[CarRentalCount] [int] NOT NULL CONSTRAINT [DF_t_Car_CarRentalCount] DEFAULT ((0)),
[TotalCarRentsD] [float] NOT NULL CONSTRAINT [DF_t_Car_TotalCarRentsD] DEFAULT ((0)),
[TotalCarRentsLL] [float] NOT NULL CONSTRAINT [DF_t_Car_TotalCarRentsLL] DEFAULT ((0)),
[TotalCarRentsEuro] [float] NOT NULL CONSTRAINT [DF_t_Car_TotalCarRentsEuro] DEFAULT ((0)),
[ProfitCarRentsD] [float] NOT NULL CONSTRAINT [DF_t_Car_ProfitCarRentsD] DEFAULT ((0)),
[ProfitCarRentsLL] [float] NOT NULL CONSTRAINT [DF_t_Car_ProfitCarRentsLL] DEFAULT ((0)),
[ProfitCarRentsEuro] [float] NOT NULL CONSTRAINT [DF_t_Car_ProfitCarRentsEuro] DEFAULT ((0)),
[ExpensesCount] [int] NOT NULL CONSTRAINT [DF_t_Car_ExpensesCount] DEFAULT ((0)),
[TotalExpensesD] [float] NOT NULL CONSTRAINT [DF_t_Car_TotalExpensesD] DEFAULT ((0)),
[TotalExpensesLL] [float] NOT NULL CONSTRAINT [DF_t_Car_TotalExpensesLL] DEFAULT ((0)),
[TotalExpensesEuro] [float] NOT NULL CONSTRAINT [DF_t_Car_TotalExpensesEuro] DEFAULT ((0)),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_Car_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_Car_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_Car_ProfitEuro] DEFAULT ((0)),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Car_IsSync] DEFAULT ((0)),
[IsSyncImage] [bit] NOT NULL CONSTRAINT [DF_t_Car_IsSyncImage] DEFAULT ((0)),
[IsSyncDamagesImage] [bit] NOT NULL CONSTRAINT [DF_t_Car_IsSyncDamagesImage] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Car_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Cars].[tr_Car] ON [Cars].[t_Car]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
    AND NOT UPDATE(IsSyncImage)
    AND NOT UPDATE(IsSyncDamagesImage)
  BEGIN 

    UPDATE  Cars.t_Car
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Car.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            1 ,
            'car'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            1 ,
            'car'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Car, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Cars].[t_Car] ADD CONSTRAINT [PK_t_Car] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Car_VehicleIdentificationNumber] ON [Cars].[t_Car] ([VehicleIdentificationNumber]) ON [PRIMARY]
GO
ALTER TABLE [Cars].[t_Car] ADD CONSTRAINT [CarClassKeyCar] FOREIGN KEY ([ClassID]) REFERENCES [Cars].[t_CarClass] ([ID])
GO
ALTER TABLE [Cars].[t_Car] ADD CONSTRAINT [CarMakeKeyCar] FOREIGN KEY ([MakeID]) REFERENCES [Cars].[t_CarMake] ([ID])
GO
ALTER TABLE [Cars].[t_Car] ADD CONSTRAINT [CarModelKeyCar] FOREIGN KEY ([ModelID]) REFERENCES [Cars].[t_CarModel] ([ID])
GO
ALTER TABLE [Cars].[t_Car] ADD CONSTRAINT [CurrencyKeyCar] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Available = 0
Unavailable = 1', 'SCHEMA', N'Cars', 'TABLE', N't_Car', 'COLUMN', N'AvailabilityIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rent = 0
Sale = 1
Exchange = 2', 'SCHEMA', N'Cars', 'TABLE', N't_Car', 'COLUMN', N'CarFor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unknown = 0
Gasoline = 1
Diesel = 2
Gas = 3
Electric = 4
Hybrid = 5
Petrol = 6
PetrolGas = 7', 'SCHEMA', N'Cars', 'TABLE', N't_Car', 'COLUMN', N'FuelType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active = 0
Inactive = 1
Blocked = 2', 'SCHEMA', N'Cars', 'TABLE', N't_Car', 'COLUMN', N'StatusIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unknown = 0
Manual = 1
Automatic = 2
ContinuouslyVariable = 3
SemiAutomatic = 4
DualClutch = 5', 'SCHEMA', N'Cars', 'TABLE', N't_Car', 'COLUMN', N'Transmission'
GO
