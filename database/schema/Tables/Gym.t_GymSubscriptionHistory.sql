CREATE TABLE [Gym].[t_GymSubscriptionHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_RefPaper] DEFAULT (''),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_DateIs] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_DateYearly] DEFAULT (getdate()),
[ToDate] [date] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ToDate] DEFAULT (getdate()),
[TransactionDate] [date] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_TransactionDate] DEFAULT (getdate()),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_IsActive] DEFAULT ((1)),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_AccountNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[SubscriptionTypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_SubscriptionTypeID] DEFAULT ([Gym].[f_SubscriptionTypeGetFirstID]()),
[SubscriptionType] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_SubscriptionType] DEFAULT ([Gym].[f_SubscriptionTypeGetFirstName]()),
[PersonalTrainerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainerID] DEFAULT ([Gym].[f_PersonalTrainerGetFirstID]()),
[PersonalTrainer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainer] DEFAULT ([Gym].[f_PersonalTrainerGetFirstName]()),
[AccountEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_AccountEmployeeID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_AccountEmployee] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountEmployeeNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_AccountEmployeeNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[NumberOfClasses] [int] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_NumberOfClasses] DEFAULT ((0)),
[ClassesNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesNames] DEFAULT (''),
[ClassesEmployeesNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesEmployeesNames] DEFAULT (''),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_AccountBoxID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountBox] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_AccountBox] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountBoxNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_AccountBoxNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PaymentMethod] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[SubscriptionTypePrice] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_SubscriptionTypePrice] DEFAULT ((0)),
[SubscriptionTypePriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_SubscriptionTypePriceF] DEFAULT ('0'),
[SubscriptionTypePriceD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_SubscriptionTypePriceD] DEFAULT ((0)),
[SubscriptionTypePriceLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_SubscriptionTypePriceLL] DEFAULT ((0)),
[SubscriptionTypePriceEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_SubscriptionTypePriceEuro] DEFAULT ((0)),
[PersonalTrainerPrice] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainerPrice] DEFAULT ((0)),
[PersonalTrainerPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainerPriceF] DEFAULT ('0'),
[PersonalTrainerPriceD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainerPriceD] DEFAULT ((0)),
[PersonalTrainerPriceLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainerPriceLL] DEFAULT ((0)),
[PersonalTrainerPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainerPriceEuro] DEFAULT ((0)),
[PersonalTrainerSalary] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainerSalary] DEFAULT ((0)),
[PersonalTrainerSalaryF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainerSalaryF] DEFAULT ('0'),
[PersonalTrainerSalaryD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainerSalaryD] DEFAULT ((0)),
[PersonalTrainerSalaryLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainerSalaryLL] DEFAULT ((0)),
[PersonalTrainerSalaryEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PersonalTrainerSalaryEuro] DEFAULT ((0)),
[ClassesPrice] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesPrice] DEFAULT ((0)),
[ClassesPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesPriceF] DEFAULT ('0'),
[ClassesPriceD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesPriceD] DEFAULT ((0)),
[ClassesPriceLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesPriceLL] DEFAULT ((0)),
[ClassesPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesPriceEuro] DEFAULT ((0)),
[ClassesSalary] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesSalary] DEFAULT ((0)),
[ClassesSalaryF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesSalaryF] DEFAULT ('0'),
[ClassesSalaryD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesSalaryD] DEFAULT ((0)),
[ClassesSalaryLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesSalaryLL] DEFAULT ((0)),
[ClassesSalaryEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ClassesSalaryEuro] DEFAULT ((0)),
[Subtotal] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_Subtotal] DEFAULT ((0)),
[SubtotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_SubtotalF] DEFAULT ('0'),
[SubtotalD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_SubtotalD] DEFAULT ((0)),
[SubtotalLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_SubtotalLL] DEFAULT ((0)),
[SubtotalEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_SubtotalEuro] DEFAULT ((0)),
[Discount] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_Discount] DEFAULT ((0)),
[DiscountF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_DiscountF] DEFAULT ('0'),
[DiscountD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_DiscountD] DEFAULT ((0)),
[DiscountLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_DiscountLL] DEFAULT ((0)),
[DiscountEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_DiscountEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_TotalEuro] DEFAULT ((0)),
[TotalAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_TotalAR] DEFAULT (''),
[TotalEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_TotalEN] DEFAULT (''),
[FirstPayment] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_FirstPayment] DEFAULT ((0)),
[FirstPaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_FirstPaymentF] DEFAULT ('0'),
[FirstPaymentD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_FirstPaymentD] DEFAULT ((0)),
[FirstPaymentLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_FirstPaymentLL] DEFAULT ((0)),
[FirstPaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_FirstPaymentEuro] DEFAULT ((0)),
[Payment] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_Payment] DEFAULT ((0)),
[PaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PaymentF] DEFAULT ('0'),
[PaymentD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PaymentD] DEFAULT ((0)),
[PaymentLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PaymentLL] DEFAULT ((0)),
[PaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_PaymentEuro] DEFAULT ((0)),
[Rest] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_Rest] DEFAULT ((0)),
[RestF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_RestF] DEFAULT ('0'),
[RestD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_RestD] DEFAULT ((0)),
[RestLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_RestLL] DEFAULT ((0)),
[RestEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_RestEuro] DEFAULT ((0)),
[IsPaid] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_IsPaid] DEFAULT ((0)),
[IsPaidSalary] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_IsPaidSalary] DEFAULT ((0)),
[AreClassesSalariesPaid] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_AreClassesSalariesPaid] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_CostEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_ProfitEuro] DEFAULT ((0)),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_GymSubscriptionHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Gym].[tr_GymSubscriptionHistory] ON [Gym].[t_GymSubscriptionHistory]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Gym.t_GymSubscriptionHistory
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_GymSubscriptionHistory.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'gymSubscriptionHistory'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'gymSubscriptionHistory'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, GymSubscription, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Gym].[t_GymSubscriptionHistory] ADD CONSTRAINT [PK_t_GymSubscriptionHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Gym].[t_GymSubscriptionHistory] ADD CONSTRAINT [AccountBoxKeyGymSubscriptionHistory] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionHistory] ADD CONSTRAINT [AccountEmployeeKeyGymSubscriptionHistory] FOREIGN KEY ([AccountEmployeeID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionHistory] ADD CONSTRAINT [AccountKeyGymSubscriptionHistory] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionHistory] ADD CONSTRAINT [CurrencyKeyGymSubscriptionHistory] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionHistory] ADD CONSTRAINT [PersonalTrainerKeyGymSubscriptionHistory] FOREIGN KEY ([PersonalTrainerID]) REFERENCES [Gym].[t_PersonalTrainer] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionHistory] ADD CONSTRAINT [SubscriptionTypeKeyGymSubscriptionHistory] FOREIGN KEY ([SubscriptionTypeID]) REFERENCES [Gym].[t_SubscriptionType] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionHistory] ADD CONSTRAINT [UserKeyGymSubscriptionHistory] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cash = 0
OnAccount = 1', 'SCHEMA', N'Gym', 'TABLE', N't_GymSubscriptionHistory', 'COLUMN', N'PaymentMethod'
GO
