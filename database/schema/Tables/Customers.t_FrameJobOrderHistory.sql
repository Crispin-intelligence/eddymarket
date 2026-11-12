CREATE TABLE [Customers].[t_FrameJobOrderHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_RefPaper] DEFAULT (''),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DateIs] DEFAULT (getdate()),
[DateDelivery] [date] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DateDelivery] DEFAULT (getdate()),
[DateInProcess] [date] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DateInProcess] DEFAULT (datefromparts((2000),(1),(1))),
[DateInProcessNotification] [date] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DateInProcessNotification] DEFAULT (datefromparts((2000),(1),(1))),
[DateReady] [date] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DateReady] DEFAULT (datefromparts((2000),(1),(1))),
[DateReadyNotification] [date] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DateReadyNotification] DEFAULT (datefromparts((2000),(1),(1))),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_StatusIs] DEFAULT ((0)),
[PriorityLevel] [tinyint] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_PriorityLevel] DEFAULT ((0)),
[CustomerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_CustomerID] DEFAULT ([Customers].[f_CustomerGetFirstID]()),
[Customer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Customer] DEFAULT ([Customers].[f_CustomerGetFirstName]()),
[DoctorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DoctorID] DEFAULT ([Company].[f_DoctorGetFirstID]()),
[Doctor] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Doctor] DEFAULT ([Company].[f_DoctorGetFirstName]()),
[SalespersonID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_SalespersonID] DEFAULT ([Employees].[f_SalesPersonGetFirstID]()),
[Salesperson] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Salesperson] DEFAULT ([Employees].[f_SalesPersonGetFirstName]()),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[RegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_RegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[RegionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_RegionIs] DEFAULT ([Location].[f_RegionGetFirstName]()),
[StreetID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_StreetID] DEFAULT ([Location].[f_StreetGetFirstID]()),
[Street] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Street] DEFAULT ([Location].[f_StreetGetFirstName]()),
[AddressIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_AddressIs] DEFAULT (''),
[Focal] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Focal] DEFAULT ('Plano'),
[WithRight] [bit] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_WithRight] DEFAULT ((1)),
[WithLeft] [bit] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_WithLeft] DEFAULT ((1)),
[SphereRight] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_SphereRight] DEFAULT ((0)),
[SphereLeft] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_SphereLeft] DEFAULT ((0)),
[CylinderRight] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_CylinderRight] DEFAULT ((0)),
[CylinderLeft] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_CylinderLeft] DEFAULT ((0)),
[AxisRight] [int] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_AxisRight] DEFAULT ((0)),
[AxisLeft] [int] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_AxisLeft] DEFAULT ((0)),
[PrismRight] [int] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_PrismRight] DEFAULT ((0)),
[PrismLeft] [int] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_PrismLeft] DEFAULT ((0)),
[BaseRight] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_BaseRight] DEFAULT ('Up'),
[BaseLeft] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_BaseLeft] DEFAULT ('Up'),
[Addition] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Addition] DEFAULT ((0)),
[HeightRight] [int] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_HeightRight] DEFAULT ((0)),
[HeightLeft] [int] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_HeightLeft] DEFAULT ((0)),
[PDRight] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_PDRight] DEFAULT ((0)),
[PDLeft] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_PDLeft] DEFAULT ((0)),
[PD] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_PD] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[SubTotal] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_SubTotal] DEFAULT ((0)),
[SubTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_SubTotalF] DEFAULT ('0'),
[SubTotalD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_SubTotalD] DEFAULT ((0)),
[SubTotalLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_SubTotalLL] DEFAULT ((0)),
[SubTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_SubTotalEuro] DEFAULT ((0)),
[DiscountIs] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DiscountIsF] DEFAULT ('0'),
[DiscountIsD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DiscountIsD] DEFAULT ((0)),
[DiscountIsLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DiscountIsLL] DEFAULT ((0)),
[DiscountIsEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DiscountIsEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_TaxValueEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_TotalEuro] DEFAULT ((0)),
[Payment] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Payment] DEFAULT ((0)),
[PaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_PaymentF] DEFAULT ('0'),
[PaymentD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_PaymentD] DEFAULT ((0)),
[PaymentLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_PaymentLL] DEFAULT ((0)),
[PaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_PaymentEuro] DEFAULT ((0)),
[Rest] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Rest] DEFAULT ((0)),
[RestF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_RestF] DEFAULT ('0'),
[RestD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_RestD] DEFAULT ((0)),
[RestLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_RestLL] DEFAULT ((0)),
[RestEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_RestEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_CostEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_ProfitEuro] DEFAULT ((0)),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_Qtys] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DescriptionIs] DEFAULT (''),
[WhyCanceled] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_WhyCanceled] DEFAULT (''),
[SoldID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_SoldID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[SoldRefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_SoldRefF] DEFAULT (''),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_ItemsNames] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [Customers].[tr_FrameJobOrderHistory] ON [Customers].[t_FrameJobOrderHistory]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Customers.t_FrameJobOrderHistory
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_FrameJobOrderHistory.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'frameJobOrderHistory'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'frameJobOrderHistory'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, FrameJobOrder, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCustomer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;

GO
ALTER TABLE [Customers].[t_FrameJobOrderHistory] ADD CONSTRAINT [PK_t_FrameJobOrderHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Customers].[t_FrameJobOrderHistory] ADD CONSTRAINT [CurrencyKeyFrameJobOrderHistory] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Customers].[t_FrameJobOrderHistory] ADD CONSTRAINT [CustomerKeyFrameJobOrderHistory] FOREIGN KEY ([CustomerID]) REFERENCES [Customers].[t_Customer] ([ID])
GO
ALTER TABLE [Customers].[t_FrameJobOrderHistory] ADD CONSTRAINT [DoctorKeyFrameJobOrderHistory] FOREIGN KEY ([DoctorID]) REFERENCES [Company].[t_Doctor] ([ID])
GO
ALTER TABLE [Customers].[t_FrameJobOrderHistory] ADD CONSTRAINT [RegionKeyFrameJobOrderHistory] FOREIGN KEY ([RegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Customers].[t_FrameJobOrderHistory] ADD CONSTRAINT [SalesPersonKeyFrameJobOrderHistory] FOREIGN KEY ([SalespersonID]) REFERENCES [Employees].[t_SalesPerson] ([ID])
GO
ALTER TABLE [Customers].[t_FrameJobOrderHistory] ADD CONSTRAINT [StatesKeyFrameJobOrderHistory] FOREIGN KEY ([StatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Customers].[t_FrameJobOrderHistory] ADD CONSTRAINT [StreetKeyFrameJobOrderHistory] FOREIGN KEY ([StreetID]) REFERENCES [Location].[t_Street] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Up
Down
In
Out', 'SCHEMA', N'Customers', 'TABLE', N't_FrameJobOrderHistory', 'COLUMN', N'BaseLeft'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Up
Down
In
Out', 'SCHEMA', N'Customers', 'TABLE', N't_FrameJobOrderHistory', 'COLUMN', N'BaseRight'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Plano
Single Distance
Single Intermediate
Single Near
Bifocal
Progressive', 'SCHEMA', N'Customers', 'TABLE', N't_FrameJobOrderHistory', 'COLUMN', N'Focal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal = 0
Important = 1
VeryImportant = 2', 'SCHEMA', N'Customers', 'TABLE', N't_FrameJobOrderHistory', 'COLUMN', N'PriorityLevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Open = 0
InProcess = 1
Ready = 2
Closed = 3
Canceled = 4', 'SCHEMA', N'Customers', 'TABLE', N't_FrameJobOrderHistory', 'COLUMN', N'StatusIs'
GO
