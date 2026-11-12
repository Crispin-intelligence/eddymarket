CREATE TABLE [Items].[t_UnityItem]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_UnityItem_ID] DEFAULT (newsequentialid()),
[UnityID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_UnityItem_UnityID] DEFAULT ([Items].[f_UnityGetFirstID]()),
[Unity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UnityItem_Unity] DEFAULT ([Items].[f_UnityGetFirstName]()),
[SharedID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_UnityItem_Qty] DEFAULT ((1)),
[QtyCurrent] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_UnityItem_QtyCurrent] DEFAULT ((0)),
[PrimaryIs] [bit] NOT NULL CONSTRAINT [DF_t_UnityItem_PrimaryIs] DEFAULT ((1)),
[Purchasing] [bit] NOT NULL CONSTRAINT [DF_t_UnityItem_Purchasing] DEFAULT ((1)),
[Sold] [bit] NOT NULL CONSTRAINT [DF_t_UnityItem_Sold] DEFAULT ((1)),
[Inventory] [bit] NOT NULL CONSTRAINT [DF_t_UnityItem_Inventory] DEFAULT ((1)),
[UseInTransfer] [bit] NOT NULL CONSTRAINT [DF_t_UnityItem_UseInTransfer] DEFAULT ((1)),
[BarCode] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UnityItem_BarCode] DEFAULT (''),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_UnityItem_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UnityItem_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[Price] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UnityItem_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_PriceEuro] DEFAULT ((0)),
[PriceWithTax] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_PriceWithTax] DEFAULT ((0)),
[PriceWithTaxF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UnityItem_PriceWithTaxF] DEFAULT ('0'),
[PriceWithTaxD] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_PriceWithTaxD] DEFAULT ((0)),
[PriceWithTaxLL] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_PriceWithTaxLL] DEFAULT ((0)),
[PriceWithTaxEuro] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_PriceWithTaxEuro] DEFAULT ((0)),
[LowestPrice] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_LowestPrice] DEFAULT ((0)),
[LowestPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UnityItem_LowestPriceF] DEFAULT ('0'),
[LowestPriceD] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_LowestPriceD] DEFAULT ((0)),
[CurrencyIDCost] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_UnityItem_CurrencyIDCost] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[CurrencyCost] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UnityItem_CurrencyCost] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UnityItem_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_CostEuro] DEFAULT ((0)),
[CostWithTax] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_CostWithTax] DEFAULT ((0)),
[CostWithTaxF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UnityItem_CostWithTaxF] DEFAULT ('0'),
[CostWithTaxD] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_CostWithTaxD] DEFAULT ((0)),
[CostWithTaxLL] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_CostWithTaxLL] DEFAULT ((0)),
[CostWithTaxEuro] [float] NOT NULL CONSTRAINT [DF_t_UnityItem_CostWithTaxEuro] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_UnityItem_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_UnityItem_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_UnityItem_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_UnityItem_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_UnityItem] ON [Items].[t_UnityItem]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_UnityItem
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_UnityItem.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'unityItem'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'unityItem'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Items].[t_UnityItem] ADD CONSTRAINT [PK_t_UnityItem] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_UnityItem_SharedID_UnityID] ON [Items].[t_UnityItem] ([SharedID], [UnityID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_UnityItem] ADD CONSTRAINT [ItemSharedKeyUnityItem] FOREIGN KEY ([SharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Items].[t_UnityItem] ADD CONSTRAINT [UnityKeyUnityItem] FOREIGN KEY ([UnityID]) REFERENCES [Items].[t_Unity] ([ID])
GO
