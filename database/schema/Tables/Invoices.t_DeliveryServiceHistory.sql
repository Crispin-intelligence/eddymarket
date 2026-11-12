CREATE TABLE [Invoices].[t_DeliveryServiceHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_RefPaper] DEFAULT (''),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DateOnly] DEFAULT (getdate()),
[TimeOnly] [time] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_TimeOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DateYearly] DEFAULT (getdate()),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_TypeIs] DEFAULT ((0)),
[TypeIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_TypeIsAR] DEFAULT ('تسليم بضاعة'),
[TypeIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_TypeIsEN] DEFAULT ('Item Delivery'),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_StatusIs] DEFAULT ((0)),
[StatusIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_StatusIsAR] DEFAULT ('تم الاستلام'),
[StatusIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_StatusIsEN] DEFAULT ('Received'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DescriptionIs] DEFAULT (''),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[AccountVendorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_AccountVendorID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountVendor] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_AccountVendor] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountVendorNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_AccountVendorNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[FromAddress] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_FromAddress] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ItemsNames] DEFAULT (''),
[CostCurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_CostCurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[CostCurrency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_CostCurrency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[CostExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_CostExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[CostExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_CostExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[CostExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_CostExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_CostEuro] DEFAULT ((0)),
[Payment] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_Payment] DEFAULT ((0)),
[PaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_PaymentF] DEFAULT ('0'),
[PaymentD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_PaymentD] DEFAULT ((0)),
[PaymentLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_PaymentLL] DEFAULT ((0)),
[PaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_PaymentEuro] DEFAULT ((0)),
[Rest] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_Rest] DEFAULT ((0)),
[RestF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_RestF] DEFAULT ('0'),
[RestD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_RestD] DEFAULT ((0)),
[RestLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_RestLL] DEFAULT ((0)),
[RestEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_RestEuro] DEFAULT ((0)),
[AccountCustomerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_AccountCustomerID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountCustomer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_AccountCustomer] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountCustomerNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_AccountCustomerNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[AccountCustomerIsVendor] [bit] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_AccountCustomerIsVendor] DEFAULT ((0)),
[ToAddress] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ToAddress] DEFAULT (''),
[DeliveryDate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryDate] DEFAULT (getdate()),
[DeliveryChargeCurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeCurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[DeliveryChargeCurrency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeCurrency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[DeliveryChargeExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[DeliveryChargeExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[DeliveryChargeExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[DeliveryCharge] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryCharge] DEFAULT ((0)),
[DeliveryChargeF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeF] DEFAULT ('0'),
[DeliveryChargeD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeD] DEFAULT ((0)),
[DeliveryChargeLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeLL] DEFAULT ((0)),
[DeliveryChargeEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeEuro] DEFAULT ((0)),
[DeliveryChargeStatus] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeStatus] DEFAULT ((0)),
[DeliveryChargeStatusAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeStatusAR] DEFAULT ('غير مدفوع'),
[DeliveryChargeStatusEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DeliveryChargeStatusEN] DEFAULT ('Unpaid'),
[AccountEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_AccountEmployeeID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[AccountEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_AccountEmployee] DEFAULT (''),
[AccountEmployeeNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_AccountEmployeeNumber] DEFAULT (''),
[AssignDate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_AssignDate] DEFAULT (datetimefromparts((2000),(1),(1),(0),(0),(0),(0))),
[Expense] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_Expense] DEFAULT ((0)),
[ExpenseF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ExpenseF] DEFAULT ('0'),
[ExpenseD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ExpenseD] DEFAULT ((0)),
[ExpenseLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ExpenseLL] DEFAULT ((0)),
[ExpenseEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ExpenseEuro] DEFAULT ((0)),
[ExpenseStatus] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ExpenseStatus] DEFAULT ((0)),
[ExpenseStatusAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ExpenseStatusAR] DEFAULT ('غير مدفوع'),
[ExpenseStatusEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ExpenseStatusEN] DEFAULT ('Unpaid'),
[ExpensePaymentDate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ExpensePaymentDate] DEFAULT (datetimefromparts((2000),(1),(1),(0),(0),(0),(0))),
[ProcessIn] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_ProcessIn] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_DeliveryServiceHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_DeliveryServiceHistory] ON [Invoices].[t_DeliveryServiceHistory]
    AFTER INSERT, UPDATE, DELETE
AS
    BEGIN

        BEGIN --Live

            UPDATE  Alls.t_LiveVersion
            SET     VersionLive = STUFF(VersionLive, DeliveryService, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
                    SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

        END;

    END;
GO
ALTER TABLE [Invoices].[t_DeliveryServiceHistory] ADD CONSTRAINT [PK_t_DeliveryServiceHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_DeliveryServiceHistory_AccountVendorID_RefPaper] ON [Invoices].[t_DeliveryServiceHistory] ([AccountVendorID], [RefPaper]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_DeliveryServiceHistory_Ref] ON [Invoices].[t_DeliveryServiceHistory] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_DeliveryServiceHistory] ADD CONSTRAINT [AccountCustomerKeyDeliveryServiceHistory] FOREIGN KEY ([AccountCustomerID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryServiceHistory] WITH NOCHECK ADD CONSTRAINT [AccountEmployeeKeyDeliveryServiceHistory] FOREIGN KEY ([AccountEmployeeID]) REFERENCES [Company].[t_Account] ([ID]) NOT FOR REPLICATION
GO
ALTER TABLE [Invoices].[t_DeliveryServiceHistory] ADD CONSTRAINT [AccountVendorKeyDeliveryServiceHistory] FOREIGN KEY ([AccountVendorID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryServiceHistory] ADD CONSTRAINT [CurrencyCostKeyDeliveryServiceHistory] FOREIGN KEY ([CostCurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryServiceHistory] ADD CONSTRAINT [CurrencyDeliveryChargeKeyDeliveryServiceHistory] FOREIGN KEY ([DeliveryChargeCurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryServiceHistory] ADD CONSTRAINT [UserKeyDeliveryServiceHistory] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryServiceHistory] NOCHECK CONSTRAINT [AccountEmployeeKeyDeliveryServiceHistory]
GO
EXEC sp_addextendedproperty N'MS_Description', N'NotPaid = 0
Paid = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'DeliveryChargeStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'غير مدفوع
مدفوع', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'DeliveryChargeStatusAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unpaid
Paid', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'DeliveryChargeStatusEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'NotPaid = 0
Paid = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'ExpenseStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'غير مدفوع
مدفوع', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'ExpenseStatusAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unpaid
Paid', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'ExpenseStatusEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Uncompleted = 0
Completed = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'ProcessIn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Received = 0
Assigned = 1
OnTheWay = 2
Delivered = 3
Completed = 4
Canceled = 5', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'StatusIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تم الاستلام
معيين
علي الطريق
تم التوصيل
مكتمل
ألغيت', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'StatusIsAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Received
Assigned
On the Way
Delivered
Completed
Canceled', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'StatusIsEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ItemDelivery = 0
Taxi = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'TypeIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تسليم بضاعة
تاكسي', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'TypeIsAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item Delivery
Taxi', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceHistory', 'COLUMN', N'TypeIsEN'
GO
ALTER TABLE [Invoices].[t_DeliveryServiceHistory] NOCHECK CONSTRAINT [AccountEmployeeKeyDeliveryServiceHistory]
GO
