CREATE TABLE [Customers].[t_FrameJobOrderHistoryDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_ID] DEFAULT (newsequentialid()),
[FrameJobOrderHistoryID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_QtyWithUnity] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_Qtys] DEFAULT ((0)),
[ItemType] [tinyint] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_ItemType] DEFAULT ((0)),
[Sale] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_Sale] DEFAULT ((0)),
[SaleF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_SaleF] DEFAULT ('0'),
[SaleD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_SaleD] DEFAULT ((0)),
[SaleLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_SaleLL] DEFAULT ((0)),
[SaleEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_SaleEuro] DEFAULT ((0)),
[DiscountIs] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountIsF] DEFAULT ('0 %'),
[DiscountIsValue] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountIsValue] DEFAULT ((0)),
[DiscountIsValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountIsValueF] DEFAULT ('0'),
[DiscountIsValueD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountIsValueD] DEFAULT ((0)),
[DiscountIsValueLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountIsValueLL] DEFAULT ((0)),
[DiscountIsValueEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountIsValueEuro] DEFAULT ((0)),
[SubTotal] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_SubTotal] DEFAULT ((0)),
[SubTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_SubTotalF] DEFAULT ('0'),
[SubTotalD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_SubTotalD] DEFAULT ((0)),
[SubTotalLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_SubTotalLL] DEFAULT ((0)),
[SubTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_SubTotalEuro] DEFAULT ((0)),
[DiscountOrder] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountOrder] DEFAULT ((0)),
[DiscountOrderF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountOrderF] DEFAULT ('0'),
[DiscountOrderD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountOrderD] DEFAULT ((0)),
[DiscountOrderLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountOrderLL] DEFAULT ((0)),
[DiscountOrderEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DiscountOrderEuro] DEFAULT ((0)),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TaxRate] DEFAULT ((0)),
[TaxRateF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TaxRateF] DEFAULT ('0 %'),
[TaxValue] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TaxValue] DEFAULT ((0)),
[TaxValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TaxValueF] DEFAULT ('0'),
[TaxValueD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TaxValueD] DEFAULT ((0)),
[TaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TaxValueLL] DEFAULT ((0)),
[TaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TaxValueEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TotalEuro] DEFAULT ((0)),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_CostEuro] DEFAULT ((0)),
[TotalCost] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TotalCost] DEFAULT ((0)),
[TotalCostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TotalCostF] DEFAULT ('0'),
[TotalCostD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TotalCostD] DEFAULT ((0)),
[TotalCostLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TotalCostLL] DEFAULT ((0)),
[TotalCostEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_TotalCostEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_ProfitEuro] DEFAULT ((0)),
[ProfitTotal] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_ProfitTotal] DEFAULT ((0)),
[ProfitTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_ProfitTotalF] DEFAULT ('0'),
[ProfitTotalD] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_ProfitTotalD] DEFAULT ((0)),
[ProfitTotalLL] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_ProfitTotalLL] DEFAULT ((0)),
[ProfitTotalEuro] [float] NOT NULL,
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_FrameJobOrderHistoryDetail_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [Customers].[tr_FrameJobOrderHistoryDetail] ON [Customers].[t_FrameJobOrderHistoryDetail]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Customers.t_FrameJobOrderHistoryDetail
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_FrameJobOrderHistoryDetail.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'frameJobOrderHistoryDetail'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'frameJobOrderHistoryDetail'
    FROM    Inserted AS s;

  END;

END;

GO
ALTER TABLE [Customers].[t_FrameJobOrderHistoryDetail] ADD CONSTRAINT [PK_t_FrameJobOrderHistoryDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Customers].[t_FrameJobOrderHistoryDetail] ADD CONSTRAINT [FrameJobOrderHistoryKeyFrameJobOrderHistoryDetail] FOREIGN KEY ([FrameJobOrderHistoryID]) REFERENCES [Customers].[t_FrameJobOrderHistory] ([ID])
GO
ALTER TABLE [Customers].[t_FrameJobOrderHistoryDetail] ADD CONSTRAINT [ItemKeyFrameJobOrderHistoryDetail] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Customers].[t_FrameJobOrderHistoryDetail] ADD CONSTRAINT [ItemSharedKeyFrameJobOrderHistoryDetail] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Customers].[t_FrameJobOrderHistoryDetail] ADD CONSTRAINT [UnityItemKeyFrameJobOrderHistoryDetail] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'RightLens = 0
LeftLens = 1
Frame = 2
Service = 3', 'SCHEMA', N'Customers', 'TABLE', N't_FrameJobOrderHistoryDetail', 'COLUMN', N'ItemType'
GO
