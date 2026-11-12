CREATE TABLE [Invoices].[t_Sold]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Sold_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_Sold_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_RefPaper] DEFAULT (''),
[RefPurchaseOrder] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_RefPurchaseOrder] DEFAULT (''),
[SaveFrom] [tinyint] NOT NULL CONSTRAINT [DF_t_Sold_SaveFrom] DEFAULT ((0)),
[QuotationID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Sold_QuotationID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[QuotationRef] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_QuotationRef] DEFAULT (''),
[InvoiceTitleID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Sold_InvoiceTitleID] DEFAULT ([Invoices].[f_InvoiceTitleGetFirstID]()),
[InvoiceTitle] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_InvoiceTitle] DEFAULT ([Invoices].[f_InvoiceTitleGetFirstName]()),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_Sold_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_Sold_DateOnly] DEFAULT (getdate()),
[TimeOnly] [time] NOT NULL CONSTRAINT [DF_t_Sold_TimeOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_Sold_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_Sold_DateYearly] DEFAULT (getdate()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Sold_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[SalespersonID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Sold_SalespersonID] DEFAULT ([Employees].[f_SalesPersonGetFirstID]()),
[Salesperson] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_Salesperson] DEFAULT ([Employees].[f_SalesPersonGetFirstName]()),
[CommissionRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_Sold_CommissionRate] DEFAULT ((0)),
[CommissionRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_CommissionRateF] DEFAULT ('0 %'),
[CommissionRateType] [tinyint] NOT NULL CONSTRAINT [DF_t_Sold_CommissionRateType] DEFAULT ((0)),
[CommissionRateOn] [tinyint] NOT NULL CONSTRAINT [DF_t_Sold_CommissionRateOn] DEFAULT ((0)),
[StatusPayment] [tinyint] NOT NULL CONSTRAINT [DF_t_Sold_StatusPayment] DEFAULT ((1)),
[CommissionValue] [float] NOT NULL CONSTRAINT [DF_t_Sold_CommissionValue] DEFAULT ((0)),
[CommissionValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_CommissionValueF] DEFAULT ('0'),
[CommissionValueD] [float] NOT NULL CONSTRAINT [DF_t_Sold_CommissionValueD] DEFAULT ((0)),
[CommissionValueLL] [float] NOT NULL CONSTRAINT [DF_t_Sold_CommissionValueLL] DEFAULT ((0)),
[CommissionValueEuro] [float] NOT NULL CONSTRAINT [DF_t_Sold_CommissionValueEuro] DEFAULT ((0)),
[SalespersonTakeCommission] [bit] NOT NULL CONSTRAINT [DF_t_Sold_SalespersonTakeCommission] DEFAULT ((1)),
[CommissionAvailableValue] [float] NOT NULL CONSTRAINT [DF_t_Sold_CommissionAvailableValue] DEFAULT ((0)),
[CommissionAvailableValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_CommissionAvailableValueF] DEFAULT ('0'),
[CommissionAvailableValueD] [float] NOT NULL CONSTRAINT [DF_t_Sold_CommissionAvailableValueD] DEFAULT ((0)),
[CommissionAvailableValueLL] [float] NOT NULL CONSTRAINT [DF_t_Sold_CommissionAvailableValueLL] DEFAULT ((0)),
[CommissionAvailableValueEuro] [float] NOT NULL CONSTRAINT [DF_t_Sold_CommissionAvailableValueEuro] DEFAULT ((0)),
[AccountCustomerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Sold_AccountCustomerID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountCustomer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_AccountCustomer] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountCustomerNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_AccountCustomerNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Sold_AccountBoxID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[AccountBox] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_AccountBox] DEFAULT (''),
[AccountBoxNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_AccountBoxNumber] DEFAULT (''),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_Sold_PaymentMethod] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Sold_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Sold_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Sold_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Sold_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[TaxExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Sold_TaxExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[TaxExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Sold_TaxExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Total] [float] NOT NULL CONSTRAINT [DF_t_Sold_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_Sold_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_Sold_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_Sold_TotalEuro] DEFAULT ((0)),
[DiscountIs] [float] NOT NULL CONSTRAINT [DF_t_Sold_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_DiscountIsF] DEFAULT ('0'),
[DiscountIsD] [float] NOT NULL CONSTRAINT [DF_t_Sold_DiscountIsD] DEFAULT ((0)),
[DiscountIsLL] [float] NOT NULL CONSTRAINT [DF_t_Sold_DiscountIsLL] DEFAULT ((0)),
[DiscountIsEuro] [float] NOT NULL CONSTRAINT [DF_t_Sold_DiscountIsEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_Sold_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_Sold_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_Sold_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_Sold_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_Sold_TaxValueEuro] DEFAULT ((0)),
[NetIs] [float] NOT NULL CONSTRAINT [DF_t_Sold_NetIs] DEFAULT ((0)),
[NetIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_NetIsF] DEFAULT ('0'),
[NetIsD] [float] NOT NULL CONSTRAINT [DF_t_Sold_NetIsD] DEFAULT ((0)),
[NetIsLL] [float] NOT NULL CONSTRAINT [DF_t_Sold_NetIsLL] DEFAULT ((0)),
[NetIsEuro] [float] NOT NULL CONSTRAINT [DF_t_Sold_NetIsEuro] DEFAULT ((0)),
[NetIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_NetIsAR] DEFAULT (''),
[NetIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_NetIsEN] DEFAULT (''),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_Sold_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_Sold_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_Sold_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_Sold_ProfitEuro] DEFAULT ((0)),
[FirstPayment] [float] NOT NULL CONSTRAINT [DF_t_Sold_FirstPayment] DEFAULT ((0)),
[FirstPaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_FirstPaymentF] DEFAULT ('0'),
[FirstPaymentD] [float] NOT NULL CONSTRAINT [DF_t_Sold_FirstPaymentD] DEFAULT ((0)),
[FirstPaymentLL] [float] NOT NULL CONSTRAINT [DF_t_Sold_FirstPaymentLL] DEFAULT ((0)),
[FirstPaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_Sold_FirstPaymentEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_Sold_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_Sold_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_Sold_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_Sold_CostEuro] DEFAULT ((0)),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_Sold_Qtys] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_DescriptionIs] DEFAULT (''),
[WFPFrom] [bit] NOT NULL CONSTRAINT [DF_t_Sold_WFPFrom] DEFAULT ((0)),
[WFPShopID] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_WFPShopID] DEFAULT (''),
[WFPBranchID] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_WFPBranchID] DEFAULT (''),
[WFPReported] [bit] NOT NULL CONSTRAINT [DF_t_Sold_WFPReported] DEFAULT ((1)),
[FrameJobOrderID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Sold_FrameJobOrderID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[FrameJobOrderRefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_FrameJobOrderRefF] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_ItemsNames] DEFAULT (''),
[ItemHaveDiscount] [bit] NOT NULL CONSTRAINT [DF_t_Sold_ItemHaveDiscount] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Sold_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Sold_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Sold_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Sold_WorkStationID] DEFAULT ((1))
) ON [Invoices] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_Sold] ON [Invoices].[t_Sold]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_Sold
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Sold.ID );

  END;
 
  BEGIN --Declare

    DECLARE @Profit AS TABLE
      (
        DateOnly DATE NOT NULL ,
        Qtys DECIMAL(18, 2) NULL ,
        NetIsD FLOAT NULL ,
        NetIsLL FLOAT NULL ,
        NetIsEuro FLOAT NULL ,
        CostD FLOAT NULL ,
        CostLL FLOAT NULL ,
        CostEuro FLOAT NULL ,
        SalesCommissionD FLOAT NULL ,
        SalesCommissionLL FLOAT NULL ,
        SalesCommissionEuro FLOAT NULL ,
        ProfitD FLOAT NULL ,
        ProfitLL FLOAT NULL ,
        ProfitEuro FLOAT NULL
      );

    DECLARE @CommissionAvailable AS TABLE
      (
        SalespersonID UNIQUEIDENTIFIER NOT NULL ,
        CommissionAvailableValueD FLOAT NOT NULL ,
        CommissionAvailableValueLL FLOAT NOT NULL ,
        CommissionAvailableValueEuro FLOAT NOT NULL
      );

  END;

  BEGIN --Set info

    INSERT  INTO @Profit
            ( DateOnly ,
              Qtys ,
              NetIsD ,
              NetIsLL ,
              NetIsEuro ,
              CostD ,
              CostLL ,
              CostEuro ,
              SalesCommissionD ,
              SalesCommissionLL ,
              SalesCommissionEuro ,
              ProfitD ,
              ProfitLL ,
              ProfitEuro
            )
    SELECT  o.DateOnly ,
            COALESCE(SUM(o.Qtys), 0) ,
            COALESCE(SUM(o.NetIsD), 0) ,
            COALESCE(SUM(o.NetIsLL), 0) ,
            COALESCE(SUM(o.NetIsEuro), 0) ,
            COALESCE(SUM(o.CostD), 0) ,
            COALESCE(SUM(o.CostLL), 0) ,
            COALESCE(SUM(o.CostEuro), 0) ,
            COALESCE(SUM(o.CommissionValueD), 0) ,
            COALESCE(SUM(o.CommissionValueLL), 0) ,
            COALESCE(SUM(o.CommissionValueEuro), 0) ,
            COALESCE(SUM(o.ProfitD), 0) ,
            COALESCE(SUM(o.ProfitLL), 0) ,
            COALESCE(SUM(o.ProfitEuro), 0)
    FROM    ( SELECT  s.DateOnly ,
                      s.Qtys ,
                      s.NetIsD ,
                      s.NetIsLL ,
                      s.NetIsEuro ,
                      s.CostD ,
                      s.CostLL ,
                      s.CostEuro ,
                      s.CommissionValueD ,
                      s.CommissionValueLL ,
                      s.CommissionValueEuro ,
                      s.ProfitD ,
                      s.ProfitLL ,
                      s.ProfitEuro
              FROM    Inserted AS s
              UNION ALL
              SELECT  s.DateOnly ,
                      0 - s.Qtys ,
                      0 - s.NetIsD ,
                      0 - s.NetIsLL ,
                      0 - s.NetIsEuro ,
                      0 - s.CostD ,
                      0 - s.CostLL ,
                      0 - s.CostEuro ,
                      0 - s.CommissionValueD ,
                      0 - s.CommissionValueLL ,
                      0 - s.CommissionValueEuro ,
                      0 - s.ProfitD ,
                      0 - s.ProfitLL ,
                      0 - s.ProfitEuro
              FROM    Deleted AS s
            ) AS o
    GROUP BY o.DateOnly;

    INSERT  INTO @CommissionAvailable
            ( SalespersonID ,
              CommissionAvailableValueD ,
              CommissionAvailableValueLL ,
              CommissionAvailableValueEuro
            )
    SELECT  o.SalespersonID ,
            COALESCE(SUM(o.CommissionAvailableValueD), 0) ,
            COALESCE(SUM(o.CommissionAvailableValueLL), 0) ,
            COALESCE(SUM(o.CommissionAvailableValueEuro), 0)
    FROM    ( SELECT  s.SalespersonID ,
                      s.CommissionAvailableValueD ,
                      s.CommissionAvailableValueLL ,
                      s.CommissionAvailableValueEuro
              FROM    Inserted AS s
              UNION ALL
              SELECT  s.SalespersonID ,
                      0 - s.CommissionAvailableValueD ,
                      0 - s.CommissionAvailableValueLL ,
                      0 - s.CommissionAvailableValueEuro
              FROM    Deleted AS s
            ) AS o
    GROUP BY o.SalespersonID;

  END;

  BEGIN --Merge t_ProfitDaily

    MERGE Invoices.t_ProfitDaily AS t
    USING @Profit AS s
    ON s.DateOnly = t.DateIs
    WHEN NOT MATCHED BY TARGET THEN
      INSERT ( DateIs ,
               SalesQtys ,
               SalesD ,
               SalesLL ,
               SalesEuro ,
               CostD ,
               CostLL ,
               CostEuro ,
               SalesCommissionD ,
               SalesCommissionLL ,
               SalesCommissionEuro ,
               ProfitGrossD ,
               ProfitGrossLL ,
               ProfitGrossEuro
             )
      VALUES ( s.DateOnly ,
               s.Qtys ,
               s.NetIsD ,
               s.NetIsLL ,
               s.NetIsEuro ,
               s.CostD ,
               s.CostLL ,
               s.CostEuro ,
               s.SalesCommissionD ,
               s.SalesCommissionLL ,
               s.SalesCommissionEuro ,
               s.ProfitD ,
               s.ProfitLL ,
               s.ProfitEuro
             )
    WHEN MATCHED THEN
      UPDATE SET
               t.SalesQtys += s.Qtys ,
               t.SalesD += s.NetIsD ,
               t.SalesLL += s.NetIsLL ,
               t.SalesEuro += s.NetIsEuro ,
               t.CostD += s.CostD ,
               t.CostLL += s.CostLL ,
               t.CostEuro += s.CostEuro ,
               t.SalesCommissionD += s.SalesCommissionD ,
               t.SalesCommissionLL += s.SalesCommissionLL ,
               t.SalesCommissionEuro += s.SalesCommissionEuro ,
               t.ProfitGrossD += s.ProfitD ,
               t.ProfitGrossLL += s.ProfitLL ,
               t.ProfitGrossEuro += s.ProfitEuro;

  END;

  BEGIN --Merge t_SalesPerson

    MERGE Employees.t_SalesPerson AS t
    USING @CommissionAvailable AS s
    ON s.SalespersonID = t.ID
    WHEN MATCHED THEN
      UPDATE SET
               t.CommissionAvailableValueD += s.CommissionAvailableValueD ,
               t.CommissionAvailableValueDF = Currencys.f_FormatD(t.CommissionAvailableValueD + s.CommissionAvailableValueD) ,
               t.CommissionAvailableValueLL += s.CommissionAvailableValueLL ,
               t.CommissionAvailableValueLLF = Currencys.f_FormatLL(t.CommissionAvailableValueLL + s.CommissionAvailableValueLL) ,
               t.CommissionAvailableValueEuro += s.CommissionAvailableValueEuro ,
               t.CommissionAvailableValueEuroF = Currencys.f_FormatEuro(t.CommissionAvailableValueEuro + s.CommissionAvailableValueEuro);

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'sold'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'sold'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Sell, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Invoices].[t_Sold] ADD CONSTRAINT [PK_t_Sold] PRIMARY KEY CLUSTERED  ([ID]) ON [Invoices]
GO
ALTER TABLE [Invoices].[t_Sold] WITH NOCHECK ADD CONSTRAINT [AccountBoxKeySold] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID]) NOT FOR REPLICATION
GO
ALTER TABLE [Invoices].[t_Sold] ADD CONSTRAINT [AccountCustomerKeySold] FOREIGN KEY ([AccountCustomerID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Invoices].[t_Sold] ADD CONSTRAINT [CurrencyKeySold] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Invoices].[t_Sold] ADD CONSTRAINT [InvoiceTitleKeySold] FOREIGN KEY ([InvoiceTitleID]) REFERENCES [Invoices].[t_InvoiceTitle] ([ID])
GO
ALTER TABLE [Invoices].[t_Sold] ADD CONSTRAINT [SalesPersonKeySold] FOREIGN KEY ([SalespersonID]) REFERENCES [Employees].[t_SalesPerson] ([ID])
GO
ALTER TABLE [Invoices].[t_Sold] ADD CONSTRAINT [UserKeySold] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Invoices].[t_Sold] NOCHECK CONSTRAINT [AccountBoxKeySold]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Net = 0
Profit = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_Sold', 'COLUMN', N'CommissionRateOn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales = 0
Collection = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_Sold', 'COLUMN', N'CommissionRateType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'cash = 0
onAccount = 1
schedulePayment = 2', 'SCHEMA', N'Invoices', 'TABLE', N't_Sold', 'COLUMN', N'PaymentMethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal = 0
Quotation = 1
FrameJobOrder = 2', 'SCHEMA', N'Invoices', 'TABLE', N't_Sold', 'COLUMN', N'SaveFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'not Collected = 0
collection = 1', 'SCHEMA', N'Invoices', 'TABLE', N't_Sold', 'COLUMN', N'StatusPayment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_Sold', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_Sold', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_Sold', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_Sold', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Without Tax And Invoice Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_Sold', 'COLUMN', N'TotalLL'
GO
ALTER TABLE [Invoices].[t_Sold] NOCHECK CONSTRAINT [AccountBoxKeySold]
GO
ALTER TABLE [Invoices].[t_Sold] NOCHECK CONSTRAINT [AccountBoxKeySold]
GO
