CREATE TABLE [Items].[t_Brand]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Brand_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Brand_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Brand_DescriptionIs] DEFAULT (''),
[ItemC] [int] NOT NULL CONSTRAINT [DF_t_Brand_ItemC] DEFAULT ((0)),
[PurchaseC] [bigint] NOT NULL CONSTRAINT [DF_t_Brand_PurchaseC] DEFAULT ((0)),
[PurchaseQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Brand_PurchaseQty] DEFAULT ((0.0)),
[PurchaseReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_Brand_PurchaseReturnC] DEFAULT ((0)),
[PurchaseReturnQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Brand_PurchaseReturnQty] DEFAULT ((0.0)),
[SellC] [bigint] NOT NULL CONSTRAINT [DF_t_Brand_SellC] DEFAULT ((0)),
[SellQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Brand_SellQty] DEFAULT ((0.0)),
[SellReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_Brand_SellReturnC] DEFAULT ((0)),
[SellReturnQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Brand_SellReturnQty] DEFAULT ((0.0)),
[QuotationC] [bigint] NOT NULL CONSTRAINT [DF_t_Brand_QuotationC] DEFAULT ((0)),
[QuotationQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Brand_QuotationQty] DEFAULT ((0.0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Brand_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Brand_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Brand_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Brand_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_Brand] ON [Items].[t_Brand]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_Brand
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Brand.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'brand'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'brand'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Brand, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Items].[t_Brand] ADD CONSTRAINT [PK_t_Brand] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [i_BrandName] ON [Items].[t_Brand] ([Name]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'for items', 'SCHEMA', N'Items', 'TABLE', N't_Brand', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'Items', 'TABLE', N't_Brand', 'COLUMN', N'ID'
GO
