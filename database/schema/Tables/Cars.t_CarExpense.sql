CREATE TABLE [Cars].[t_CarExpense]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarExpense_ID] DEFAULT (newsequentialid()),
[CarID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarExpense_CarID] DEFAULT ([Cars].[f_CarGetFirstID]()),
[Car] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_Car] DEFAULT ([Cars].[f_CarGetFirstName]()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_CarExpense_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_RefF] DEFAULT ('0'),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_CarExpense_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_CarExpense_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_CarExpense_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_CarExpense_DateYearly] DEFAULT (getdate()),
[ByUserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarExpense_ByUserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[ByUser] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_ByUser] DEFAULT ([Users].[f_UserGetFirstName]()),
[FromAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarExpense_FromAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[FromAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_FromAccount] DEFAULT ([Company].[f_AccountGetFirstName]()),
[FromAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_FromAccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[ToAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarExpense_ToAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[ToAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_ToAccount] DEFAULT ([Company].[f_AccountGetFirstName]()),
[ToAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_ToAccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[VendorAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarExpense_VendorAccountID] DEFAULT ([Company].[f_AccountVendorGetFirstID]()),
[VendorAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_VendorAccount] DEFAULT ([Company].[f_AccountVendorGetFirstName]()),
[VendorAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_VendorAccountNumberF] DEFAULT ([Company].[f_AccountVendorGetFirstNumberF]()),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_CarExpense_PaymentMethod] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarExpense_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_CarExpense_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_CarExpense_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_CarExpense_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[TaxExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_CarExpense_TaxExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[TaxExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_CarExpense_TaxExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Balance] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_Balance] DEFAULT ((0)),
[BalanceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_BalanceF] DEFAULT ('0'),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_BalanceEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_CarExpense_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_TaxValueEuro] DEFAULT ((0)),
[NetIs] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_NetIs] DEFAULT ((0)),
[NetIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_NetIsF] DEFAULT ('0'),
[NetIsD] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_NetIsD] DEFAULT ((0)),
[NetIsLL] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_NetIsLL] DEFAULT ((0)),
[NetIsEuro] [float] NOT NULL CONSTRAINT [DF_t_CarExpense_NetIsEuro] DEFAULT ((0)),
[NetIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_NetIsAR] DEFAULT (''),
[NetIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_NetIsEN] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_DescriptionIs] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarExpense_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarExpense_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarExpense_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarExpense_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Cars].[tr_CarExpense] ON [Cars].[t_CarExpense]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarExpense
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarExpenseSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarExpense.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carExpense'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carExpense'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarExpense, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;

GO
ALTER TABLE [Cars].[t_CarExpense] ADD CONSTRAINT [PK_t_CarExpense] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_CarExpense_Ref] ON [Cars].[t_CarExpense] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Cars].[t_CarExpense] ADD CONSTRAINT [AccountFromKeyCarExpense] FOREIGN KEY ([FromAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Cars].[t_CarExpense] ADD CONSTRAINT [AccountToKeyCarExpense] FOREIGN KEY ([ToAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Cars].[t_CarExpense] ADD CONSTRAINT [AccountVendorKeyCarExpense] FOREIGN KEY ([VendorAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Cars].[t_CarExpense] ADD CONSTRAINT [CarKeyCarExpense] FOREIGN KEY ([CarID]) REFERENCES [Cars].[t_Car] ([ID])
GO
ALTER TABLE [Cars].[t_CarExpense] ADD CONSTRAINT [CurrencyKeyCarExpense] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Cars].[t_CarExpense] ADD CONSTRAINT [UserKeyCarExpense] FOREIGN KEY ([ByUserID]) REFERENCES [Users].[t_User] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cash = 0
OnAccount = 1', 'SCHEMA', N'Cars', 'TABLE', N't_CarExpense', 'COLUMN', N'PaymentMethod'
GO
