CREATE TABLE [Gym].[t_GymClass]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymClass_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_Name] DEFAULT ('-'),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymClass_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstIDLL]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstNameLL]()),
[PriceDaily] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceDaily] DEFAULT ((0)),
[PriceDailyF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_PriceDailyF] DEFAULT ('0 L.L.'),
[PriceDailyD] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceDailyD] DEFAULT ((0)),
[PriceDailyLL] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceDailyLL] DEFAULT ((0)),
[PriceDailyEuro] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceDailyEuro] DEFAULT ((0)),
[PriceWeekly] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceWeekly] DEFAULT ((0)),
[PriceWeeklyF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_PriceWeeklyF] DEFAULT ('0 L.L.'),
[PriceWeeklyD] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceWeeklyD] DEFAULT ((0)),
[PriceWeeklyLL] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceWeeklyLL] DEFAULT ((0)),
[PriceWeeklyEuro] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceWeeklyEuro] DEFAULT ((0)),
[PriceMonthly] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceMonthly] DEFAULT ((0)),
[PriceMonthlyF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_PriceMonthlyF] DEFAULT ('0 L.L.'),
[PriceMonthlyD] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceMonthlyD] DEFAULT ((0)),
[PriceMonthlyLL] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceMonthlyLL] DEFAULT ((0)),
[PriceMonthlyEuro] [float] NOT NULL CONSTRAINT [DF_t_GymClass_PriceMonthlyEuro] DEFAULT ((0)),
[AccountEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymClass_AccountEmployeeID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_AccountEmployee] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountEmployeeNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_AccountEmployeeNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[SalaryDailyPercent] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_GymClass_SalaryDailyPercent] DEFAULT ((0)),
[SalaryDaily] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryDaily] DEFAULT ((0)),
[SalaryDailyF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_SalaryDailyF] DEFAULT ('0 L.L.'),
[SalaryDailyD] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryDailyD] DEFAULT ((0)),
[SalaryDailyLL] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryDailyLL] DEFAULT ((0)),
[SalaryDailyEuro] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryDailyEuro] DEFAULT ((0)),
[SalaryWeeklyPercent] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_GymClass_SalaryWeeklyPercent] DEFAULT ((0)),
[SalaryWeekly] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryWeekly] DEFAULT ((0)),
[SalaryWeeklyF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_SalaryWeeklyF] DEFAULT ('0 L.L.'),
[SalaryWeeklyD] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryWeeklyD] DEFAULT ((0)),
[SalaryWeeklyLL] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryWeeklyLL] DEFAULT ((0)),
[SalaryWeeklyEuro] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryWeeklyEuro] DEFAULT ((0)),
[SalaryMonthlyPercent] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_GymClass_SalaryMonthlyPercent] DEFAULT ((0)),
[SalaryMonthly] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryMonthly] DEFAULT ((0)),
[SalaryMonthlyF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_SalaryMonthlyF] DEFAULT ('0 L.L.'),
[SalaryMonthlyD] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryMonthlyD] DEFAULT ((0)),
[SalaryMonthlyLL] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryMonthlyLL] DEFAULT ((0)),
[SalaryMonthlyEuro] [float] NOT NULL CONSTRAINT [DF_t_GymClass_SalaryMonthlyEuro] DEFAULT ((0)),
[Day0] [bit] NOT NULL CONSTRAINT [DF_t_GymClass_Day0] DEFAULT ((0)),
[Day0FromTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day0FromTime] DEFAULT (getdate()),
[Day0ToTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day0ToTime] DEFAULT (getdate()),
[Day0Minutes] [int] NOT NULL CONSTRAINT [DF_t_GymClass_Day0Minutes] DEFAULT ((0)),
[Day0FromToF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_Day0FromToF] DEFAULT (''),
[Day1] [bit] NOT NULL CONSTRAINT [DF_t_GymClass_Day1] DEFAULT ((1)),
[Day1FromTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day1FromTime] DEFAULT (getdate()),
[Day1ToTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day1ToTime] DEFAULT (getdate()),
[Day1Minutes] [int] NOT NULL CONSTRAINT [DF_t_GymClass_Day1Minutes] DEFAULT ((0)),
[Day1FromToF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_Day1FromToF] DEFAULT (''),
[Day2] [bit] NOT NULL CONSTRAINT [DF_t_GymClass_Day2] DEFAULT ((1)),
[Day2FromTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day2FromTime] DEFAULT (getdate()),
[Day2ToTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day2ToTime] DEFAULT (getdate()),
[Day2Minutes] [int] NOT NULL CONSTRAINT [DF_t_GymClass_Day2Minutes] DEFAULT ((0)),
[Day2FromToF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_Day2FromToF] DEFAULT (''),
[Day3] [bit] NOT NULL CONSTRAINT [DF_t_GymClass_Day3] DEFAULT ((1)),
[Day3FromTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day3FromTime] DEFAULT (getdate()),
[Day3ToTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day3ToTime] DEFAULT (getdate()),
[Day3Minutes] [int] NOT NULL CONSTRAINT [DF_t_GymClass_Day3Minutes] DEFAULT ((0)),
[Day3FromToF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_Day3FromToF] DEFAULT (''),
[Day4] [bit] NOT NULL CONSTRAINT [DF_t_GymClass_Day4] DEFAULT ((1)),
[Day4FromTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day4FromTime] DEFAULT (getdate()),
[Day4ToTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day4ToTime] DEFAULT (getdate()),
[Day4Minutes] [int] NOT NULL CONSTRAINT [DF_t_GymClass_Day4Minutes] DEFAULT ((0)),
[Day4FromToF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_Day4FromToF] DEFAULT (''),
[Day5] [bit] NOT NULL CONSTRAINT [DF_t_GymClass_Day5] DEFAULT ((1)),
[Day5FromTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day5FromTime] DEFAULT (getdate()),
[Day5ToTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day5ToTime] DEFAULT (getdate()),
[Day5Minutes] [int] NOT NULL CONSTRAINT [DF_t_GymClass_Day5Minutes] DEFAULT ((0)),
[Day5FromToF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_Day5FromToF] DEFAULT (''),
[Day6] [bit] NOT NULL CONSTRAINT [DF_t_GymClass_Day6] DEFAULT ((1)),
[Day6FromTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day6FromTime] DEFAULT (getdate()),
[Day6ToTime] [time] NOT NULL CONSTRAINT [DF_t_GymClass_Day6ToTime] DEFAULT (getdate()),
[Day6Minutes] [int] NOT NULL CONSTRAINT [DF_t_GymClass_Day6Minutes] DEFAULT ((0)),
[Day6FromToF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_Day6FromToF] DEFAULT (''),
[DaysNamesAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_DaysNamesAR] DEFAULT (''),
[DaysNamesEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_DaysNamesEN] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymClass_DescriptionIs] DEFAULT (''),
[IsEnabled] [bit] NOT NULL CONSTRAINT [DF_t_GymClass_IsEnabled] DEFAULT ((1)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_GymClass_DateCreate] DEFAULT (getdate()),
[NumberOfSubscriptions] [bigint] NOT NULL CONSTRAINT [DF_t_GymClass_NumberOfSubscriptions] DEFAULT ((0)),
[NumberOfActiveAccounts] [int] NOT NULL CONSTRAINT [DF_t_GymClass_NumberOfActiveAccounts] DEFAULT ((0)),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_GymClass_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_GymClass_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Gym].[tr_GymClass] ON [Gym].[t_GymClass]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Gym.t_GymClass
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_GymClass.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'gymClass'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'gymClass'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, GymClass, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Gym].[t_GymClass] ADD CONSTRAINT [PK_t_GymClass] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Gym].[t_GymClass] ADD CONSTRAINT [AccountKeyGymClass] FOREIGN KEY ([AccountEmployeeID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Gym].[t_GymClass] ADD CONSTRAINT [CurrencyKeyGymClass] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
