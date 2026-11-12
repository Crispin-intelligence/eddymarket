CREATE TABLE [Items].[t_MainCategory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_MainCategory_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_MainCategory_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_MainCategory_DescriptionIs] DEFAULT (''),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_MainCategory_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImagePath] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_MainCategory_ImagePath] DEFAULT (''),
[Printer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_MainCategory_Printer] DEFAULT (''),
[SubCategoryC] [int] NOT NULL CONSTRAINT [DF_t_MainCategory_SubCategoryC] DEFAULT ((0)),
[ItemC] [int] NOT NULL CONSTRAINT [DF_t_MainCategory_ItemC] DEFAULT ((0)),
[ItemInListCount] [int] NOT NULL CONSTRAINT [DF_t_MainCategory_ItemInListCount] DEFAULT ((0)),
[PurchaseC] [bigint] NOT NULL CONSTRAINT [DF_t_MainCategory_PurchaseC] DEFAULT ((0)),
[PurchaseQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_MainCategory_PurchaseQty] DEFAULT ((0.0)),
[PurchaseReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_MainCategory_PurchaseReturnC] DEFAULT ((0)),
[PurchaseReturnQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_MainCategory_PurchaseReturnQty] DEFAULT ((0.0)),
[SellC] [bigint] NOT NULL CONSTRAINT [DF_t_MainCategory_SellC] DEFAULT ((0)),
[SellQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_MainCategory_SellQty] DEFAULT ((0.0)),
[SellReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_MainCategory_SellReturnC] DEFAULT ((0)),
[SellReturnQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_MainCategory_SellReturnQty] DEFAULT ((0.0)),
[QuotationC] [bigint] NOT NULL CONSTRAINT [DF_t_MainCategory_QuotationC] DEFAULT ((0)),
[QuotationQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_MainCategory_QuotationQty] DEFAULT ((0.0)),
[OrderBy] [bigint] NOT NULL CONSTRAINT [DF_t_MainCategory_OrderBy] DEFAULT ((1)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_MainCategory_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_MainCategory_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_MainCategory_IsSync] DEFAULT ((0)),
[IsSyncImage] [bit] NOT NULL CONSTRAINT [DF_t_MainCategory_IsSyncImage] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_MainCategory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_MainCategory] ON [Items].[t_MainCategory]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_MainCategory
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_MainCategory.ID );

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            1 ,
            'mainCategory'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            1 ,
            'mainCategory'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, MainCategory, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Items].[t_MainCategory] ADD CONSTRAINT [PK_t_MainCategory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_MainCategory_Name] ON [Items].[t_MainCategory] ([Name]) ON [PRIMARY]
GO
