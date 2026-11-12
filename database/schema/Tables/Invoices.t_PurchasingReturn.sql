CREATE TABLE [Invoices].[t_PurchasingReturn]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_RefPaper] DEFAULT (''),
[InvoiceTitleID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_InvoiceTitleID] DEFAULT ([Invoices].[f_InvoiceTitleGetFirstID]()),
[InvoiceTitle] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_InvoiceTitle] DEFAULT ([Invoices].[f_InvoiceTitleGetFirstName]()),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_DateYearly] DEFAULT (getdate()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[AccountVendorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_AccountVendorID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountVendor] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_AccountVendor] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountVendorNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_AccountVendorNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_AccountBoxID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[AccountBox] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_AccountBox] DEFAULT (''),
[AccountBoxNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_AccountBoxNumber] DEFAULT (''),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_PaymentMethod] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_PurchasingReturn_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_PurchasingReturn_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_PurchasingReturn_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[TaxExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TaxExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[TaxExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TaxExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Total] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TotalEuro] DEFAULT ((0)),
[DiscountIs] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_DiscountIsF] DEFAULT ('0'),
[DiscountIsD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_DiscountIsD] DEFAULT ((0)),
[DiscountIsLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_DiscountIsLL] DEFAULT ((0)),
[DiscountIsEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_DiscountIsEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_TaxValueEuro] DEFAULT ((0)),
[NetIs] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_NetIs] DEFAULT ((0)),
[NetIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_NetIsF] DEFAULT ('0'),
[NetIsD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_NetIsD] DEFAULT ((0)),
[NetIsLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_NetIsLL] DEFAULT ((0)),
[NetIsEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_NetIsEuro] DEFAULT ((0)),
[NetIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_NetIsAR] DEFAULT (''),
[NetIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_NetIsEN] DEFAULT (''),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_ProfitEuro] DEFAULT ((0)),
[FirstPayment] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_FirstPayment] DEFAULT ((0)),
[FirstPaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_FirstPaymentF] DEFAULT ('0'),
[FirstPaymentD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_FirstPaymentD] DEFAULT ((0)),
[FirstPaymentLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_FirstPaymentLL] DEFAULT ((0)),
[FirstPaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_FirstPaymentEuro] DEFAULT ((0)),
[Sell] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_Sell] DEFAULT ((0)),
[SellF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_SellF] DEFAULT ('0'),
[SellD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_SellD] DEFAULT ((0)),
[SellLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_SellLL] DEFAULT ((0)),
[SellEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_SellEuro] DEFAULT ((0)),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_PurchasingReturn_Qtys] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_DescriptionIs] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingReturn_ItemsNames] DEFAULT (''),
[ItemHaveDiscount] [bit] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_ItemHaveDiscount] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_PurchasingReturn_WorkStationID] DEFAULT ((1))
) ON [Invoices] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_PurchasingReturn] ON [Invoices].[t_PurchasingReturn]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_PurchasingReturn
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_PurchasingReturn.ID );

  END;
 
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'purchasingReturn'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'purchasingReturn'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, ReturnPurchased, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Invoices].[t_PurchasingReturn] ADD CONSTRAINT [PK_t_PurchasingReturn] PRIMARY KEY CLUSTERED  ([ID]) ON [Invoices]
GO
ALTER TABLE [Invoices].[t_PurchasingReturn] WITH NOCHECK ADD CONSTRAINT [AccountBoxKeyPurchasingReturn] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID]) NOT FOR REPLICATION
GO
ALTER TABLE [Invoices].[t_PurchasingReturn] ADD CONSTRAINT [AccountVendorKeyPurchasingReturn] FOREIGN KEY ([AccountVendorID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingReturn] ADD CONSTRAINT [CurrencyKeyPurchasingReturn] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingReturn] ADD CONSTRAINT [InvoiceTitleKeyPurchasingReturn] FOREIGN KEY ([InvoiceTitleID]) REFERENCES [Invoices].[t_InvoiceTitle] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingReturn] ADD CONSTRAINT [UserKeyPurchasingReturn] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingReturn] NOCHECK CONSTRAINT [AccountBoxKeyPurchasingReturn]
GO
EXEC sp_addextendedproperty N'MS_Description', N'cash = 0
onAccount = 1
schedulePayment = 2', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingReturn', 'COLUMN', N'PaymentMethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingReturn', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingReturn', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingReturn', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingReturn', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingReturn', 'COLUMN', N'TotalLL'
GO
ALTER TABLE [Invoices].[t_PurchasingReturn] NOCHECK CONSTRAINT [AccountBoxKeyPurchasingReturn]
GO
