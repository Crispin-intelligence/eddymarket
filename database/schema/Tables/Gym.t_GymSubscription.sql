CREATE TABLE [Gym].[t_GymSubscription]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscription_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_GymSubscription_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_RefPaper] DEFAULT (''),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_GymSubscription_DateIs] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_GymSubscription_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_GymSubscription_DateYearly] DEFAULT (getdate()),
[ToDate] [date] NOT NULL CONSTRAINT [DF_t_GymSubscription_ToDate] DEFAULT (getdate()),
[TransactionDate] [date] NOT NULL CONSTRAINT [DF_t_GymSubscription_TransactionDate] DEFAULT (getdate()),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscription_IsActive] DEFAULT ((1)),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscription_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_AccountNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[SubscriptionTypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscription_SubscriptionTypeID] DEFAULT ([Gym].[f_SubscriptionTypeGetFirstID]()),
[SubscriptionType] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_SubscriptionType] DEFAULT ([Gym].[f_SubscriptionTypeGetFirstName]()),
[PersonalTrainerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainerID] DEFAULT ([Gym].[f_PersonalTrainerGetFirstID]()),
[PersonalTrainer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainer] DEFAULT ([Gym].[f_PersonalTrainerGetFirstName]()),
[AccountEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscription_AccountEmployeeID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_AccountEmployee] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountEmployeeNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_AccountEmployeeNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[NumberOfClasses] [int] NOT NULL CONSTRAINT [DF_t_GymSubscription_NumberOfClasses] DEFAULT ((0)),
[ClassesNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesNames] DEFAULT (''),
[ClassesEmployeesNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesEmployeesNames] DEFAULT (''),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscription_AccountBoxID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountBox] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_AccountBox] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountBoxNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_AccountBoxNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_GymSubscription_PaymentMethod] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscription_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_GymSubscription_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_GymSubscription_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_GymSubscription_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[SubscriptionTypePrice] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_SubscriptionTypePrice] DEFAULT ((0)),
[SubscriptionTypePriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_SubscriptionTypePriceF] DEFAULT ('0'),
[SubscriptionTypePriceD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_SubscriptionTypePriceD] DEFAULT ((0)),
[SubscriptionTypePriceLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_SubscriptionTypePriceLL] DEFAULT ((0)),
[SubscriptionTypePriceEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_SubscriptionTypePriceEuro] DEFAULT ((0)),
[PersonalTrainerPrice] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainerPrice] DEFAULT ((0)),
[PersonalTrainerPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainerPriceF] DEFAULT ('0'),
[PersonalTrainerPriceD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainerPriceD] DEFAULT ((0)),
[PersonalTrainerPriceLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainerPriceLL] DEFAULT ((0)),
[PersonalTrainerPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainerPriceEuro] DEFAULT ((0)),
[PersonalTrainerSalary] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainerSalary] DEFAULT ((0)),
[PersonalTrainerSalaryF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainerSalaryF] DEFAULT ('0'),
[PersonalTrainerSalaryD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainerSalaryD] DEFAULT ((0)),
[PersonalTrainerSalaryLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainerSalaryLL] DEFAULT ((0)),
[PersonalTrainerSalaryEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_PersonalTrainerSalaryEuro] DEFAULT ((0)),
[ClassesPrice] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesPrice] DEFAULT ((0)),
[ClassesPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesPriceF] DEFAULT ('0'),
[ClassesPriceD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesPriceD] DEFAULT ((0)),
[ClassesPriceLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesPriceLL] DEFAULT ((0)),
[ClassesPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesPriceEuro] DEFAULT ((0)),
[ClassesSalary] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesSalary] DEFAULT ((0)),
[ClassesSalaryF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesSalaryF] DEFAULT ('0'),
[ClassesSalaryD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesSalaryD] DEFAULT ((0)),
[ClassesSalaryLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesSalaryLL] DEFAULT ((0)),
[ClassesSalaryEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_ClassesSalaryEuro] DEFAULT ((0)),
[Subtotal] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_Subtotal] DEFAULT ((0)),
[SubtotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_SubtotalF] DEFAULT ('0'),
[SubtotalD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_SubtotalD] DEFAULT ((0)),
[SubtotalLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_SubtotalLL] DEFAULT ((0)),
[SubtotalEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_SubtotalEuro] DEFAULT ((0)),
[Discount] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_Discount] DEFAULT ((0)),
[DiscountF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_DiscountF] DEFAULT ('0'),
[DiscountD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_DiscountD] DEFAULT ((0)),
[DiscountLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_DiscountLL] DEFAULT ((0)),
[DiscountEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_DiscountEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_TotalEuro] DEFAULT ((0)),
[TotalAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_TotalAR] DEFAULT (''),
[TotalEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_TotalEN] DEFAULT (''),
[FirstPayment] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_FirstPayment] DEFAULT ((0)),
[FirstPaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_FirstPaymentF] DEFAULT ('0'),
[FirstPaymentD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_FirstPaymentD] DEFAULT ((0)),
[FirstPaymentLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_FirstPaymentLL] DEFAULT ((0)),
[FirstPaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_FirstPaymentEuro] DEFAULT ((0)),
[Payment] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_Payment] DEFAULT ((0)),
[PaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_PaymentF] DEFAULT ('0'),
[PaymentD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_PaymentD] DEFAULT ((0)),
[PaymentLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_PaymentLL] DEFAULT ((0)),
[PaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_PaymentEuro] DEFAULT ((0)),
[Rest] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_Rest] DEFAULT ((0)),
[RestF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_RestF] DEFAULT ('0'),
[RestD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_RestD] DEFAULT ((0)),
[RestLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_RestLL] DEFAULT ((0)),
[RestEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_RestEuro] DEFAULT ((0)),
[IsPaid] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscription_IsPaid] DEFAULT ((0)),
[IsPaidSalary] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscription_IsPaidSalary] DEFAULT ((0)),
[AreClassesSalariesPaid] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscription_AreClassesSalariesPaid] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_CostEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscription_ProfitEuro] DEFAULT ((0)),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscription_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscription_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_GymSubscription_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscription_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_GymSubscription_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Gym].[tr_GymSubscription] ON [Gym].[t_GymSubscription]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Gym.t_GymSubscription
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_GymSubscription.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'gymSubscription'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'gymSubscription'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, GymSubscription, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Gym].[t_GymSubscription] ADD CONSTRAINT [PK_t_GymSubscription] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_GymSubscription_Ref] ON [Gym].[t_GymSubscription] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Gym].[t_GymSubscription] ADD CONSTRAINT [AccountBoxKeyGymSubscription] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscription] ADD CONSTRAINT [AccountEmployeeKeyGymSubscription] FOREIGN KEY ([AccountEmployeeID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscription] ADD CONSTRAINT [AccountKeyGymSubscription] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscription] ADD CONSTRAINT [CurrencyKeyGymSubscription] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscription] ADD CONSTRAINT [PersonalTrainerKeyGymSubscription] FOREIGN KEY ([PersonalTrainerID]) REFERENCES [Gym].[t_PersonalTrainer] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscription] ADD CONSTRAINT [SubscriptionTypeKeyGymSubscription] FOREIGN KEY ([SubscriptionTypeID]) REFERENCES [Gym].[t_SubscriptionType] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscription] ADD CONSTRAINT [UserKeyGymSubscription] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cash = 0
OnAccount = 1', 'SCHEMA', N'Gym', 'TABLE', N't_GymSubscription', 'COLUMN', N'PaymentMethod'
GO
