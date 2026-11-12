CREATE TABLE [Invoices].[t_SoldReturn]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldReturn_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_SoldReturn_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_RefPaper] DEFAULT (''),
[InvoiceTitleID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldReturn_InvoiceTitleID] DEFAULT ([Invoices].[f_InvoiceTitleGetFirstID]()),
[InvoiceTitle] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_InvoiceTitle] DEFAULT ([Invoices].[f_InvoiceTitleGetFirstName]()),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_SoldReturn_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_SoldReturn_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_SoldReturn_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_SoldReturn_DateYearly] DEFAULT (getdate()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldReturn_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[AccountCustomerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldReturn_AccountCustomerID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountCustomer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_AccountCustomer] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountCustomerNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_AccountCustomerNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldReturn_AccountBoxID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[AccountBox] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_AccountBox] DEFAULT (''),
[AccountBoxNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_AccountBoxNumber] DEFAULT (''),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_SoldReturn_PaymentMethod] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldReturn_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SoldReturn_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SoldReturn_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SoldReturn_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[TaxExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SoldReturn_TaxExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[TaxExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SoldReturn_TaxExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Total] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_TotalEuro] DEFAULT ((0)),
[DiscountIs] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_DiscountIsF] DEFAULT ('0'),
[DiscountIsD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_DiscountIsD] DEFAULT ((0)),
[DiscountIsLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_DiscountIsLL] DEFAULT ((0)),
[DiscountIsEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_DiscountIsEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_SoldReturn_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_TaxValueEuro] DEFAULT ((0)),
[NetIs] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_NetIs] DEFAULT ((0)),
[NetIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_NetIsF] DEFAULT ('0'),
[NetIsD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_NetIsD] DEFAULT ((0)),
[NetIsLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_NetIsLL] DEFAULT ((0)),
[NetIsEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_NetIsEuro] DEFAULT ((0)),
[NetIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_NetIsAR] DEFAULT (''),
[NetIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_NetIsEN] DEFAULT (''),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_ProfitEuro] DEFAULT ((0)),
[FirstPayment] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_FirstPayment] DEFAULT ((0)),
[FirstPaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_FirstPaymentF] DEFAULT ('0'),
[FirstPaymentD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_FirstPaymentD] DEFAULT ((0)),
[FirstPaymentLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_FirstPaymentLL] DEFAULT ((0)),
[FirstPaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_FirstPaymentEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturn_CostEuro] DEFAULT ((0)),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_SoldReturn_Qtys] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_DescriptionIs] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturn_ItemsNames] DEFAULT (''),
[ItemHaveDiscount] [bit] NOT NULL CONSTRAINT [DF_t_SoldReturn_ItemHaveDiscount] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SoldReturn_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SoldReturn_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SoldReturn_WorkStationID] DEFAULT ((1))
) ON [Invoices] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_SoldReturn] ON [Invoices].[t_SoldReturn]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_SoldReturn
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_SoldReturn.ID );

  END;
 
  BEGIN --Merge t_ProfitDaily

    MERGE Invoices.t_ProfitDaily AS t
    USING Deleted AS s
    ON s.DateOnly = t.DateIs
    WHEN MATCHED THEN
      UPDATE SET
               t.ProfitSalesRefundD -= s.ProfitD ,
               t.ProfitSalesRefundLL -= s.ProfitLL ,
               t.ProfitSalesRefundEuro -= s.ProfitEuro;

    MERGE Invoices.t_ProfitDaily AS t
    USING Inserted AS s
    ON s.DateOnly = t.DateIs
    WHEN NOT MATCHED BY TARGET THEN
      INSERT ( DateIs ,
               ProfitSalesRefundD ,
               ProfitSalesRefundLL ,
               ProfitSalesRefundEuro
             )
      VALUES ( s.DateIs ,
               s.ProfitD ,
               s.ProfitLL ,
               s.ProfitEuro
             )
    WHEN MATCHED THEN
      UPDATE SET
               t.ProfitSalesRefundD += s.ProfitD ,
               t.ProfitSalesRefundLL += s.ProfitLL ,
               t.ProfitSalesRefundEuro += s.ProfitEuro;

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'soldReturn'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'soldReturn'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, ReturnSold, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Invoices].[t_SoldReturn] ADD CONSTRAINT [PK_t_SoldReturn] PRIMARY KEY CLUSTERED  ([ID]) ON [Invoices]
GO
ALTER TABLE [Invoices].[t_SoldReturn] WITH NOCHECK ADD CONSTRAINT [AccountBoxKeySoldReturn] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID]) NOT FOR REPLICATION
GO
ALTER TABLE [Invoices].[t_SoldReturn] ADD CONSTRAINT [AccountCustomerKeySoldReturn] FOREIGN KEY ([AccountCustomerID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturn] ADD CONSTRAINT [CurrencyKeySoldReturn] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturn] ADD CONSTRAINT [InvoiceTitleKeySoldReturn] FOREIGN KEY ([InvoiceTitleID]) REFERENCES [Invoices].[t_InvoiceTitle] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturn] ADD CONSTRAINT [UserKeySoldReturn] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturn] NOCHECK CONSTRAINT [AccountBoxKeySoldReturn]
GO
EXEC sp_addextendedproperty N'MS_Description', N'cash = 0
onAccount = 1
schedulePayment = 2', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturn', 'COLUMN', N'PaymentMethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturn', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturn', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturn', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturn', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturn', 'COLUMN', N'TotalLL'
GO
ALTER TABLE [Invoices].[t_SoldReturn] NOCHECK CONSTRAINT [AccountBoxKeySoldReturn]
GO
