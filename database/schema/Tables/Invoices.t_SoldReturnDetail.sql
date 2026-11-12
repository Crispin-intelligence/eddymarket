CREATE TABLE [Invoices].[t_SoldReturnDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_ID] DEFAULT (newsequentialid()),
[SoldReturnID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_QtyWithUnity] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_Qtys] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_PriceEuro] DEFAULT ((0)),
[DiscountIs] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountIsF] DEFAULT ('0 %'),
[DiscountIsValue] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountIsValue] DEFAULT ((0)),
[DiscountIsValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountIsValueF] DEFAULT ('0'),
[DiscountIsValueD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountIsValueD] DEFAULT ((0)),
[DiscountIsValueLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountIsValueLL] DEFAULT ((0)),
[DiscountIsValueEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountIsValueEuro] DEFAULT ((0)),
[SubTotal] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_SubTotal] DEFAULT ((0)),
[SubTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_SubTotalF] DEFAULT ('0'),
[SubTotalD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_SubTotalD] DEFAULT ((0)),
[SubTotalLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_SubTotalLL] DEFAULT ((0)),
[SubTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_SubTotalEuro] DEFAULT ((0)),
[DiscountInvoice] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountInvoice] DEFAULT ((0)),
[DiscountInvoiceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountInvoiceF] DEFAULT ('0'),
[DiscountInvoiceD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountInvoiceD] DEFAULT ((0)),
[DiscountInvoiceLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountInvoiceLL] DEFAULT ((0)),
[DiscountInvoiceEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DiscountInvoiceEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_TaxValueEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_TotalEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_CostEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_ProfitEuro] DEFAULT ((0)),
[ProfitTotal] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_ProfitTotal] DEFAULT ((0)),
[ProfitTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_ProfitTotalF] DEFAULT ('0'),
[ProfitTotalD] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_ProfitTotalD] DEFAULT ((0)),
[ProfitTotalLL] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_ProfitTotalLL] DEFAULT ((0)),
[ProfitTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_ProfitTotalEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SoldReturnDetail_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SoldReturnDetails_WorkStationID] DEFAULT ((1))
) ON [Invoices] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_SoldReturnDetail] ON [Invoices].[t_SoldReturnDetail]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_SoldReturnDetail
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_SoldReturnDetail.ID );

  END;
 
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'soldReturnDetail'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'soldReturnDetail'
    FROM    Inserted AS s;

  END;
	
END;
GO
ALTER TABLE [Invoices].[t_SoldReturnDetail] ADD CONSTRAINT [PK_t_SoldReturnDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [Invoices]
GO
ALTER TABLE [Invoices].[t_SoldReturnDetail] ADD CONSTRAINT [ItemKeySoldReturnDetail] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturnDetail] ADD CONSTRAINT [ItemSharedKeySoldReturnDetail] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturnDetail] ADD CONSTRAINT [SoldReturnKeySoldReturnDetail] FOREIGN KEY ([SoldReturnID]) REFERENCES [Invoices].[t_SoldReturn] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturnDetail] ADD CONSTRAINT [UnityItemKeySoldReturnDetail] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'Cost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'CostD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'CostEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'CostF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cost of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'CostLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'SubTotal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'SubTotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'SubTotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'SubTotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'SubTotalLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_SoldReturnDetail', 'COLUMN', N'TotalLL'
GO
