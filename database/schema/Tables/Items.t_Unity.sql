CREATE TABLE [Items].[t_Unity]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Unity_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Unity_Name] DEFAULT ('قطعة'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Unity_DescriptionIs] DEFAULT (''),
[ItemC] [int] NOT NULL CONSTRAINT [DF_t_Unity_ItemC] DEFAULT ((0)),
[PurchaseC] [bigint] NOT NULL CONSTRAINT [DF_t_Unity_PurchaseC] DEFAULT ((0)),
[PurchaseQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Unity_PurchaseQty] DEFAULT ((0.0)),
[PurchaseReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_Unity_PurchaseReturnC] DEFAULT ((0)),
[PurchaseReturnQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Unity_PurchaseReturnQty] DEFAULT ((0.0)),
[SellC] [bigint] NOT NULL CONSTRAINT [DF_t_Unity_SellC] DEFAULT ((0)),
[SellQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Unity_SellQty] DEFAULT ((0.0)),
[SellReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_Unity_SellReturnC] DEFAULT ((0)),
[SellReturnQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Unity_SellReturnQty] DEFAULT ((0.0)),
[QuotationC] [bigint] NOT NULL CONSTRAINT [DF_t_Unity_QuotationC] DEFAULT ((0)),
[QuotationQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Unity_QuotationQty] DEFAULT ((0.0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Unity_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Unity_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Unity_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Unity_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_Unity] ON [Items].[t_Unity]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_Unity
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Unity.ID );

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'unity'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'unity'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Unity, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Items].[t_Unity] ADD CONSTRAINT [cc_t_Unity_Name] CHECK ((ltrim([Name])<>''))
GO
ALTER TABLE [Items].[t_Unity] ADD CONSTRAINT [PK_t_Unity] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Unity_Name] ON [Items].[t_Unity] ([Name]) ON [PRIMARY]
GO
