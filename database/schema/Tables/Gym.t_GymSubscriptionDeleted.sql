CREATE TABLE [Gym].[t_GymSubscriptionDeleted]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_RefPaper] DEFAULT (''),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_DateIs] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_DateYearly] DEFAULT (getdate()),
[ToDate] [date] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ToDate] DEFAULT (getdate()),
[TransactionDate] [date] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_TransactionDate] DEFAULT (getdate()),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_IsActive] DEFAULT ((1)),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_AccountNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[SubscriptionTypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_SubscriptionTypeID] DEFAULT ([Gym].[f_SubscriptionTypeGetFirstID]()),
[SubscriptionType] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_SubscriptionType] DEFAULT ([Gym].[f_SubscriptionTypeGetFirstName]()),
[PersonalTrainerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainerID] DEFAULT ([Gym].[f_PersonalTrainerGetFirstID]()),
[PersonalTrainer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainer] DEFAULT ([Gym].[f_PersonalTrainerGetFirstName]()),
[AccountEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_AccountEmployeeID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_AccountEmployee] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountEmployeeNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_AccountEmployeeNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[NumberOfClasses] [int] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_NumberOfClasses] DEFAULT ((0)),
[ClassesNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesNames] DEFAULT (''),
[ClassesEmployeesNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesEmployeesNames] DEFAULT (''),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_AccountBoxID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountBox] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_AccountBox] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountBoxNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_AccountBoxNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PaymentMethod] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[SubscriptionTypePrice] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_SubscriptionTypePrice] DEFAULT ((0)),
[SubscriptionTypePriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_SubscriptionTypePriceF] DEFAULT ('0'),
[SubscriptionTypePriceD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_SubscriptionTypePriceD] DEFAULT ((0)),
[SubscriptionTypePriceLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_SubscriptionTypePriceLL] DEFAULT ((0)),
[SubscriptionTypePriceEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_SubscriptionTypePriceEuro] DEFAULT ((0)),
[PersonalTrainerPrice] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainerPrice] DEFAULT ((0)),
[PersonalTrainerPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainerPriceF] DEFAULT ('0'),
[PersonalTrainerPriceD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainerPriceD] DEFAULT ((0)),
[PersonalTrainerPriceLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainerPriceLL] DEFAULT ((0)),
[PersonalTrainerPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainerPriceEuro] DEFAULT ((0)),
[PersonalTrainerSalary] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainerSalary] DEFAULT ((0)),
[PersonalTrainerSalaryF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainerSalaryF] DEFAULT ('0'),
[PersonalTrainerSalaryD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainerSalaryD] DEFAULT ((0)),
[PersonalTrainerSalaryLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainerSalaryLL] DEFAULT ((0)),
[PersonalTrainerSalaryEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PersonalTrainerSalaryEuro] DEFAULT ((0)),
[ClassesPrice] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesPrice] DEFAULT ((0)),
[ClassesPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesPriceF] DEFAULT ('0'),
[ClassesPriceD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesPriceD] DEFAULT ((0)),
[ClassesPriceLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesPriceLL] DEFAULT ((0)),
[ClassesPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesPriceEuro] DEFAULT ((0)),
[ClassesSalary] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesSalary] DEFAULT ((0)),
[ClassesSalaryF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesSalaryF] DEFAULT ('0'),
[ClassesSalaryD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesSalaryD] DEFAULT ((0)),
[ClassesSalaryLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesSalaryLL] DEFAULT ((0)),
[ClassesSalaryEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ClassesSalaryEuro] DEFAULT ((0)),
[Subtotal] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_Subtotal] DEFAULT ((0)),
[SubtotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_SubtotalF] DEFAULT ('0'),
[SubtotalD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_SubtotalD] DEFAULT ((0)),
[SubtotalLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_SubtotalLL] DEFAULT ((0)),
[SubtotalEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_SubtotalEuro] DEFAULT ((0)),
[Discount] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_Discount] DEFAULT ((0)),
[DiscountF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_DiscountF] DEFAULT ('0'),
[DiscountD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_DiscountD] DEFAULT ((0)),
[DiscountLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_DiscountLL] DEFAULT ((0)),
[DiscountEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_DiscountEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_TotalEuro] DEFAULT ((0)),
[TotalAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_TotalAR] DEFAULT (''),
[TotalEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_TotalEN] DEFAULT (''),
[FirstPayment] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_FirstPayment] DEFAULT ((0)),
[FirstPaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_FirstPaymentF] DEFAULT ('0'),
[FirstPaymentD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_FirstPaymentD] DEFAULT ((0)),
[FirstPaymentLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_FirstPaymentLL] DEFAULT ((0)),
[FirstPaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_FirstPaymentEuro] DEFAULT ((0)),
[Payment] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_Payment] DEFAULT ((0)),
[PaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PaymentF] DEFAULT ('0'),
[PaymentD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PaymentD] DEFAULT ((0)),
[PaymentLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PaymentLL] DEFAULT ((0)),
[PaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_PaymentEuro] DEFAULT ((0)),
[Rest] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_Rest] DEFAULT ((0)),
[RestF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_RestF] DEFAULT ('0'),
[RestD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_RestD] DEFAULT ((0)),
[RestLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_RestLL] DEFAULT ((0)),
[RestEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_RestEuro] DEFAULT ((0)),
[IsPaid] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_IsPaid] DEFAULT ((0)),
[IsPaidSalary] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_IsPaidSalary] DEFAULT ((0)),
[AreClassesSalariesPaid] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_AreClassesSalariesPaid] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_CostEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_ProfitEuro] DEFAULT ((0)),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_GymSubscriptionDeleted_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Gym].[tr_GymSubscriptionDeleted] ON [Gym].[t_GymSubscriptionDeleted]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Gym.t_GymSubscriptionDeleted
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_GymSubscriptionDeleted.ID );

  END;

  BEGIN --Live

    UPDATE Alls.t_LiveVersion
      SET VersionLive = STUFF(VersionLive, GymSubscription, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
          SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Gym].[t_GymSubscriptionDeleted] ADD CONSTRAINT [PK_t_GymSubscriptionDeleted] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Gym].[t_GymSubscriptionDeleted] ADD CONSTRAINT [AccountBoxKeyGymSubscriptionDeleted] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionDeleted] ADD CONSTRAINT [AccountEmployeeKeyGymSubscriptionDeleted] FOREIGN KEY ([AccountEmployeeID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionDeleted] ADD CONSTRAINT [AccountKeyGymSubscriptionDeleted] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionDeleted] ADD CONSTRAINT [CurrencyKeyGymSubscriptionDeleted] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionDeleted] ADD CONSTRAINT [PersonalTrainerKeyGymSubscriptionDeleted] FOREIGN KEY ([PersonalTrainerID]) REFERENCES [Gym].[t_PersonalTrainer] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionDeleted] ADD CONSTRAINT [SubscriptionTypeKeyGymSubscriptionDeleted] FOREIGN KEY ([SubscriptionTypeID]) REFERENCES [Gym].[t_SubscriptionType] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionDeleted] ADD CONSTRAINT [UserKeyGymSubscriptionDeleted] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cash = 0
OnAccount = 1', 'SCHEMA', N'Gym', 'TABLE', N't_GymSubscriptionDeleted', 'COLUMN', N'PaymentMethod'
GO
