CREATE TABLE [Invoices].[t_PurchasingDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_ID] DEFAULT (newsequentialid()),
[PurchasingID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_PurchasingDetail_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_QtyWithUnity] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_PurchasingDetail_Qtys] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_PriceEuro] DEFAULT ((0)),
[DiscountIs] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountIsF] DEFAULT ('0 %'),
[DiscountIsValue] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountIsValue] DEFAULT ((0)),
[DiscountIsValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountIsValueF] DEFAULT ('0'),
[DiscountIsValueD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountIsValueD] DEFAULT ((0)),
[DiscountIsValueLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountIsValueLL] DEFAULT ((0)),
[DiscountIsValueEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountIsValueEuro] DEFAULT ((0)),
[SubTotal] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_SubTotal] DEFAULT ((0)),
[SubTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_SubTotalF] DEFAULT ('0'),
[SubTotalD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_SubTotalD] DEFAULT ((0)),
[SubTotalLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_SubTotalLL] DEFAULT ((0)),
[SubTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_SubTotalEuro] DEFAULT ((0)),
[DiscountInvoice] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountInvoice] DEFAULT ((0)),
[DiscountInvoiceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountInvoiceF] DEFAULT ('0'),
[DiscountInvoiceD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountInvoiceD] DEFAULT ((0)),
[DiscountInvoiceLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountInvoiceLL] DEFAULT ((0)),
[DiscountInvoiceEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DiscountInvoiceEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_PurchasingDetail_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_TaxValueEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_TotalEuro] DEFAULT ((0)),
[Sell] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_Sell] DEFAULT ((0)),
[SellF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_SellF] DEFAULT ('0'),
[SellD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_SellD] DEFAULT ((0)),
[SellLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_SellLL] DEFAULT ((0)),
[SellEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_SellEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_ProfitEuro] DEFAULT ((0)),
[ProfitTotal] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_ProfitTotal] DEFAULT ((0)),
[ProfitTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_ProfitTotalF] DEFAULT ('0'),
[ProfitTotalD] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_ProfitTotalD] DEFAULT ((0)),
[ProfitTotalLL] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_ProfitTotalLL] DEFAULT ((0)),
[ProfitTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_ProfitTotalEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_PurchasingDetail_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_PurchasingDetails_WorkStationID] DEFAULT ((1))
) ON [Invoices] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_PurchasingDetail] ON [Invoices].[t_PurchasingDetail]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_PurchasingDetail
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_PurchasingDetail.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'purchasingDetail'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'purchasingDetail'
    FROM    Inserted AS s;

  END;
	
END;
GO
ALTER TABLE [Invoices].[t_PurchasingDetail] ADD CONSTRAINT [PK_t_PurchasingDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [Invoices]
GO
ALTER TABLE [Invoices].[t_PurchasingDetail] ADD CONSTRAINT [ItemKeyPurchasingDetail] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingDetail] ADD CONSTRAINT [ItemSharedKeyPurchasingDetail] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingDetail] ADD CONSTRAINT [PurchasingKeyPurchasingDetail] FOREIGN KEY ([PurchasingID]) REFERENCES [Invoices].[t_Purchasing] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingDetail] ADD CONSTRAINT [UnityItemKeyPurchasingDetail] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'DiscountIsValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'DiscountIsValueD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'DiscountIsValueEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'DiscountIsValueF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Discount', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'DiscountIsValueLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sell of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'Sell'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sell of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'SellD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sell of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'SellEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sell of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'SellF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sell of Item', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'SellLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'SubTotal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'SubTotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'SubTotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'SubTotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price * Qty - DiscountIsValue', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'SubTotalLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'TaxValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'TaxValueD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'TaxValueEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'TaxValueF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Tax', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'TaxValueLL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'TotalD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'TotalEuro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'TotalF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final Total', 'SCHEMA', N'Invoices', 'TABLE', N't_PurchasingDetail', 'COLUMN', N'TotalLL'
GO
