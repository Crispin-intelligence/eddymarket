CREATE TABLE [Vendors].[t_VendorSchedulePayment]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_ID] DEFAULT (newsequentialid()),
[PurchasingID] [uniqueidentifier] NOT NULL,
[VendorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_VendorID] DEFAULT ([Vendors].[f_VendorGetFirstID]()),
[Vendor] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_Vendor] DEFAULT ([Vendors].[f_VendorGetFirstName]()),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_DateIs] DEFAULT (getdate()),
[Payment] [float] NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_Payment] DEFAULT ((0)),
[PaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_PaymentF] DEFAULT ('0'),
[PaymentD] [float] NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_PaymentD] DEFAULT ((0)),
[PaymentLL] [float] NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_PaymentLL] DEFAULT ((0)),
[PaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_PaymentEuro] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_DescriptionIs] DEFAULT (''),
[IsPayment] [bit] NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_IsPayment] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_VendorSchedulePayment_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Vendors].[tr_VendorSchedulePayment]
ON [Vendors].[t_VendorSchedulePayment]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Vendor, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaVendor, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Vendors].[t_VendorSchedulePayment] ADD CONSTRAINT [PK_t_VendorSchedulePayment] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Vendors].[t_VendorSchedulePayment] ADD CONSTRAINT [CurrencyKeyVendorSchedulePayment] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Vendors].[t_VendorSchedulePayment] WITH NOCHECK ADD CONSTRAINT [PurchasingKeyVendorSchedulePayment] FOREIGN KEY ([PurchasingID]) REFERENCES [Invoices].[t_Purchasing] ([ID]) NOT FOR REPLICATION
GO
ALTER TABLE [Vendors].[t_VendorSchedulePayment] ADD CONSTRAINT [VendorKeyVendorSchedulePayment] FOREIGN KEY ([PurchasingID]) REFERENCES [Vendors].[t_Vendor] ([ID])
GO
ALTER TABLE [Vendors].[t_VendorSchedulePayment] NOCHECK CONSTRAINT [PurchasingKeyVendorSchedulePayment]
GO
