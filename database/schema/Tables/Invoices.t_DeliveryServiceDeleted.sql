CREATE TABLE [Invoices].[t_DeliveryServiceDeleted]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_RefPaper] DEFAULT (''),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DateOnly] DEFAULT (getdate()),
[TimeOnly] [time] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_TimeOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DateYearly] DEFAULT (getdate()),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_TypeIs] DEFAULT ((0)),
[TypeIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_TypeIsAR] DEFAULT ('تسليم بضاعة'),
[TypeIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_TypeIsEN] DEFAULT ('Item Delivery'),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_StatusIs] DEFAULT ((0)),
[StatusIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_StatusIsAR] DEFAULT ('تم الاستلام'),
[StatusIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_StatusIsEN] DEFAULT ('Received'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DescriptionIs] DEFAULT (''),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[AccountVendorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_AccountVendorID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountVendor] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_AccountVendor] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountVendorNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_AccountVendorNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[FromAddress] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_FromAddress] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ItemsNames] DEFAULT (''),
[CostCurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_CostCurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[CostCurrency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_CostCurrency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[CostExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_CostExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[CostExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_CostExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[CostExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_CostExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_CostEuro] DEFAULT ((0)),
[Payment] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_Payment] DEFAULT ((0)),
[PaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_PaymentF] DEFAULT ('0'),
[PaymentD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_PaymentD] DEFAULT ((0)),
[PaymentLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_PaymentLL] DEFAULT ((0)),
[PaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_PaymentEuro] DEFAULT ((0)),
[Rest] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_Rest] DEFAULT ((0)),
[RestF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_RestF] DEFAULT ('0'),
[RestD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_RestD] DEFAULT ((0)),
[RestLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_RestLL] DEFAULT ((0)),
[RestEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_RestEuro] DEFAULT ((0)),
[AccountCustomerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_AccountCustomerID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountCustomer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_AccountCustomer] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountCustomerNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_AccountCustomerNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[AccountCustomerIsVendor] [bit] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_AccountCustomerIsVendor] DEFAULT ((0)),
[ToAddress] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ToAddress] DEFAULT (''),
[DeliveryDate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryDate] DEFAULT (getdate()),
[DeliveryChargeCurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeCurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[DeliveryChargeCurrency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeCurrency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[DeliveryChargeExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[DeliveryChargeExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[DeliveryChargeExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[DeliveryCharge] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryCharge] DEFAULT ((0)),
[DeliveryChargeF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeF] DEFAULT ('0'),
[DeliveryChargeD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeD] DEFAULT ((0)),
[DeliveryChargeLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeLL] DEFAULT ((0)),
[DeliveryChargeEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeEuro] DEFAULT ((0)),
[DeliveryChargeStatus] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeStatus] DEFAULT ((0)),
[DeliveryChargeStatusAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeStatusAR] DEFAULT ('غير مدفوع'),
[DeliveryChargeStatusEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DeliveryChargeStatusEN] DEFAULT ('Unpaid'),
[AccountEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_AccountEmployeeID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[AccountEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_AccountEmployee] DEFAULT (''),
[AccountEmployeeNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_AccountEmployeeNumber] DEFAULT (''),
[AssignDate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_AssignDate] DEFAULT (datetimefromparts((2000),(1),(1),(0),(0),(0),(0))),
[Expense] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_Expense] DEFAULT ((0)),
[ExpenseF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ExpenseF] DEFAULT ('0'),
[ExpenseD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ExpenseD] DEFAULT ((0)),
[ExpenseLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ExpenseLL] DEFAULT ((0)),
[ExpenseEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ExpenseEuro] DEFAULT ((0)),
[ExpenseStatus] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ExpenseStatus] DEFAULT ((0)),
[ExpenseStatusAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ExpenseStatusAR] DEFAULT ('غير مدفوع'),
[ExpenseStatusEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ExpenseStatusEN] DEFAULT ('Unpaid'),
[ExpensePaymentDate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ExpensePaymentDate] DEFAULT (datetimefromparts((2000),(1),(1),(0),(0),(0),(0))),
[ProcessIn] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_ProcessIn] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_DeliveryServiceDeleted_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_DeliveryServiceDeleted] ON [Invoices].[t_DeliveryServiceDeleted]
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
ALTER TABLE [Invoices].[t_DeliveryServiceDeleted] ADD CONSTRAINT [PK_t_DeliveryServiceDeleted] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_DeliveryServiceDeleted] ADD CONSTRAINT [AccountCustomerKeyDeliveryServiceDeleted] FOREIGN KEY ([AccountCustomerID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryServiceDeleted] WITH NOCHECK ADD CONSTRAINT [AccountEmployeeKeyDeliveryServiceDeleted] FOREIGN KEY ([AccountEmployeeID]) REFERENCES [Company].[t_Account] ([ID]) NOT FOR REPLICATION
GO
ALTER TABLE [Invoices].[t_DeliveryServiceDeleted] ADD CONSTRAINT [AccountVendorKeyDeliveryServiceDeleted] FOREIGN KEY ([AccountVendorID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryServiceDeleted] ADD CONSTRAINT [CurrencyCostKeyDeliveryServiceDeleted] FOREIGN KEY ([CostCurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryServiceDeleted] ADD CONSTRAINT [CurrencyDeliveryChargeKeyDeliveryServiceDeleted] FOREIGN KEY ([DeliveryChargeCurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryServiceDeleted] ADD CONSTRAINT [UserKeyDeliveryServiceDeleted] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryServiceDeleted] NOCHECK CONSTRAINT [AccountEmployeeKeyDeliveryServiceDeleted]
GO
EXEC sp_addextendedproperty N'MS_Description', N'NotPaid = 0
Paid = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'DeliveryChargeStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'غير مدفوع
مدفوع', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'DeliveryChargeStatusAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unpaid
Paid', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'DeliveryChargeStatusEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'NotPaid = 0
Paid = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'ExpenseStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'غير مدفوع
مدفوع', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'ExpenseStatusAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unpaid
Paid', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'ExpenseStatusEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Uncompleted = 0
Completed = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'ProcessIn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Received = 0
Assigned = 1
OnTheWay = 2
Delivered = 3
Completed = 4
Canceled = 5', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'StatusIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تم الاستلام
معيين
علي الطريق
تم التوصيل
مكتمل
ألغيت', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'StatusIsAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Received
Assigned
On the Way
Delivered
Completed
Canceled', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'StatusIsEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ItemDelivery = 0
Taxi = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'TypeIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تسليم بضاعة
تاكسي', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'TypeIsAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item Delivery
Taxi', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryServiceDeleted', 'COLUMN', N'TypeIsEN'
GO
