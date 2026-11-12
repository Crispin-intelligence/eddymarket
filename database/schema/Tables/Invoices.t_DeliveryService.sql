CREATE TABLE [Invoices].[t_DeliveryService]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryService_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_DeliveryService_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_RefPaper] DEFAULT (''),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryService_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_DeliveryService_DateOnly] DEFAULT (getdate()),
[TimeOnly] [time] NOT NULL CONSTRAINT [DF_t_DeliveryService_TimeOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_DeliveryService_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_DeliveryService_DateYearly] DEFAULT (getdate()),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryService_TypeIs] DEFAULT ((0)),
[TypeIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_TypeIsAR] DEFAULT ('تسليم بضاعة'),
[TypeIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_TypeIsEN] DEFAULT ('Item Delivery'),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryService_StatusIs] DEFAULT ((0)),
[StatusIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_StatusIsAR] DEFAULT ('تم الاستلام'),
[StatusIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_StatusIsEN] DEFAULT ('Received'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_DescriptionIs] DEFAULT (''),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryService_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[AccountVendorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryService_AccountVendorID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountVendor] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_AccountVendor] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountVendorNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_AccountVendorNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[FromAddress] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_FromAddress] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_ItemsNames] DEFAULT (''),
[CostCurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryService_CostCurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[CostCurrency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_CostCurrency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[CostExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryService_CostExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[CostExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryService_CostExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[CostExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryService_CostExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_CostEuro] DEFAULT ((0)),
[Payment] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_Payment] DEFAULT ((0)),
[PaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_PaymentF] DEFAULT ('0'),
[PaymentD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_PaymentD] DEFAULT ((0)),
[PaymentLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_PaymentLL] DEFAULT ((0)),
[PaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_PaymentEuro] DEFAULT ((0)),
[Rest] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_Rest] DEFAULT ((0)),
[RestF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_RestF] DEFAULT ('0'),
[RestD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_RestD] DEFAULT ((0)),
[RestLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_RestLL] DEFAULT ((0)),
[RestEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_RestEuro] DEFAULT ((0)),
[AccountCustomerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryService_AccountCustomerID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountCustomer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_AccountCustomer] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountCustomerNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_AccountCustomerNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[AccountCustomerIsVendor] [bit] NOT NULL CONSTRAINT [DF_t_DeliveryService_AccountCustomerIsVendor] DEFAULT ((0)),
[ToAddress] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_ToAddress] DEFAULT (''),
[DeliveryDate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryDate] DEFAULT (getdate()),
[DeliveryChargeCurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeCurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[DeliveryChargeCurrency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeCurrency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[DeliveryChargeExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[DeliveryChargeExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[DeliveryChargeExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[DeliveryCharge] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryCharge] DEFAULT ((0)),
[DeliveryChargeF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeF] DEFAULT ('0'),
[DeliveryChargeD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeD] DEFAULT ((0)),
[DeliveryChargeLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeLL] DEFAULT ((0)),
[DeliveryChargeEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeEuro] DEFAULT ((0)),
[DeliveryChargeStatus] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeStatus] DEFAULT ((0)),
[DeliveryChargeStatusAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeStatusAR] DEFAULT ('غير مدفوع'),
[DeliveryChargeStatusEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_DeliveryChargeStatusEN] DEFAULT ('Unpaid'),
[AccountEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DeliveryService_AccountEmployeeID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[AccountEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_AccountEmployee] DEFAULT (''),
[AccountEmployeeNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_AccountEmployeeNumber] DEFAULT (''),
[AssignDate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryService_AssignDate] DEFAULT (datetimefromparts((2000),(1),(1),(0),(0),(0),(0))),
[Expense] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_Expense] DEFAULT ((0)),
[ExpenseF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_ExpenseF] DEFAULT ('0'),
[ExpenseD] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_ExpenseD] DEFAULT ((0)),
[ExpenseLL] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_ExpenseLL] DEFAULT ((0)),
[ExpenseEuro] [float] NOT NULL CONSTRAINT [DF_t_DeliveryService_ExpenseEuro] DEFAULT ((0)),
[ExpenseStatus] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryService_ExpenseStatus] DEFAULT ((0)),
[ExpenseStatusAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_ExpenseStatusAR] DEFAULT ('غير مدفوع'),
[ExpenseStatusEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DeliveryService_ExpenseStatusEN] DEFAULT ('Unpaid'),
[ExpensePaymentDate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryService_ExpensePaymentDate] DEFAULT (datetimefromparts((2000),(1),(1),(0),(0),(0),(0))),
[ProcessIn] [tinyint] NOT NULL CONSTRAINT [DF_t_DeliveryService_ProcessIn] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_DeliveryService_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_DeliveryService_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_DeliveryService_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_DeliveryService] ON [Invoices].[t_DeliveryService]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_DeliveryService
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_DeliveryService.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'deliveryService'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'deliveryService'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, DeliveryService, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Invoices].[t_DeliveryService] ADD CONSTRAINT [PK_t_DeliveryService] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_DeliveryService_AccountVendorID_RefPaper] ON [Invoices].[t_DeliveryService] ([AccountVendorID], [RefPaper]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_DeliveryService_Ref] ON [Invoices].[t_DeliveryService] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_DeliveryService] ADD CONSTRAINT [AccountCustomerKeyDeliveryService] FOREIGN KEY ([AccountCustomerID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryService] WITH NOCHECK ADD CONSTRAINT [AccountEmployeeKeyDeliveryService] FOREIGN KEY ([AccountEmployeeID]) REFERENCES [Company].[t_Account] ([ID]) NOT FOR REPLICATION
GO
ALTER TABLE [Invoices].[t_DeliveryService] ADD CONSTRAINT [AccountVendorKeyDeliveryService] FOREIGN KEY ([AccountVendorID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryService] ADD CONSTRAINT [CurrencyCostKeyDeliveryService] FOREIGN KEY ([CostCurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryService] ADD CONSTRAINT [CurrencyDeliveryChargeKeyDeliveryService] FOREIGN KEY ([DeliveryChargeCurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryService] ADD CONSTRAINT [UserKeyDeliveryService] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Invoices].[t_DeliveryService] NOCHECK CONSTRAINT [AccountEmployeeKeyDeliveryService]
GO
EXEC sp_addextendedproperty N'MS_Description', N'NotPaid = 0
Paid = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'DeliveryChargeStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'غير مدفوع
مدفوع', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'DeliveryChargeStatusAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unpaid
Paid', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'DeliveryChargeStatusEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'NotPaid = 0
Paid = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'ExpenseStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'غير مدفوع
مدفوع', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'ExpenseStatusAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unpaid
Paid', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'ExpenseStatusEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Uncompleted = 0
Completed = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'ProcessIn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Received = 0
Assigned = 1
OnTheWay = 2
Delivered = 3
Completed = 4
Canceled = 5', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'StatusIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تم الاستلام
معيين
علي الطريق
تم التوصيل
مكتمل
ألغيت', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'StatusIsAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Received
Assigned
On the Way
Delivered
Completed
Canceled', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'StatusIsEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ItemDelivery = 0
Taxi = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'TypeIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تسليم بضاعة
تاكسي', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'TypeIsAR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item Delivery
Taxi', 'SCHEMA', N'Invoices', 'TABLE', N't_DeliveryService', 'COLUMN', N'TypeIsEN'
GO
ALTER TABLE [Invoices].[t_DeliveryService] NOCHECK CONSTRAINT [AccountEmployeeKeyDeliveryService]
GO
