CREATE TABLE [Company].[t_Expense]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Expense_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_Expense_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_RefF] DEFAULT ('0'),
[LinkedType] [int] NOT NULL CONSTRAINT [DF_t_Expense_LinkedType] DEFAULT ((69)),
[LinkID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Expense_LinkID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[LinkRef] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_LinkRef] DEFAULT (''),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_Expense_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_Expense_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_Expense_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_Expense_DateYearly] DEFAULT (getdate()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Expense_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[FromAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Expense_FromAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[FromAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_FromAccount] DEFAULT ([Company].[f_AccountGetFirstName]()),
[FromAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_FromAccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[ToAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Expense_ToAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[ToAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_ToAccount] DEFAULT ([Company].[f_AccountGetFirstName]()),
[ToAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_ToAccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[VendorAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Expense_VendorAccountID] DEFAULT ([Company].[f_AccountVendorGetFirstID]()),
[VendorAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_VendorAccount] DEFAULT ([Company].[f_AccountVendorGetFirstName]()),
[VendorAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_VendorAccountNumberF] DEFAULT ([Company].[f_AccountVendorGetFirstNumberF]()),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_Expense_PaymentMethod] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Expense_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Expense_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Expense_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Expense_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[TaxExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Expense_TaxExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[TaxExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Expense_TaxExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Balance] [float] NOT NULL CONSTRAINT [DF_t_Expense_Balance] DEFAULT ((0)),
[BalanceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_BalanceF] DEFAULT ('0'),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_Expense_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_Expense_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_Expense_BalanceEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_Expense_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_Expense_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_Expense_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_Expense_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_Expense_TaxValueEuro] DEFAULT ((0)),
[NetIs] [float] NOT NULL CONSTRAINT [DF_t_Expense_NetIs] DEFAULT ((0)),
[NetIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_NetIsF] DEFAULT ('0'),
[NetIsD] [float] NOT NULL CONSTRAINT [DF_t_Expense_NetIsD] DEFAULT ((0)),
[NetIsLL] [float] NOT NULL CONSTRAINT [DF_t_Expense_NetIsLL] DEFAULT ((0)),
[NetIsEuro] [float] NOT NULL CONSTRAINT [DF_t_Expense_NetIsEuro] DEFAULT ((0)),
[NetIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_NetIsAR] DEFAULT (''),
[NetIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_NetIsEN] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Expense_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Expense_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Expense_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Expense_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_Expense] ON [Company].[t_Expense]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_Expense
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Expense.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'expense'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'expense'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Expense, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_Expense] ADD CONSTRAINT [PK_t_Expense] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_Expense] ADD CONSTRAINT [AccountFromKeyExpense] FOREIGN KEY ([FromAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_Expense] ADD CONSTRAINT [AccountKeyExpense] FOREIGN KEY ([VendorAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_Expense] ADD CONSTRAINT [AccountToKeyExpense] FOREIGN KEY ([ToAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_Expense] ADD CONSTRAINT [CurrencyKeyExpense] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Company].[t_Expense] ADD CONSTRAINT [UserKeyExpense] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchasing = 0
None = 69
CarRental = 185', 'SCHEMA', N'Company', 'TABLE', N't_Expense', 'COLUMN', N'LinkedType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cash = 0
OnAccount = 1', 'SCHEMA', N'Company', 'TABLE', N't_Expense', 'COLUMN', N'PaymentMethod'
GO
