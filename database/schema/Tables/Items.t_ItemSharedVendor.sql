CREATE TABLE [Items].[t_ItemSharedVendor]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_ID] DEFAULT (newsequentialid()),
[SharedID] [uniqueidentifier] NOT NULL,
[VendorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_VendorID] DEFAULT ([Vendors].[f_VendorGetFirstID]()),
[Vendor] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_Vendor] DEFAULT ([Vendors].[f_VendorGetFirstName]()),
[ItemCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_ItemCode] DEFAULT (''),
[UnitIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_UnitIs] DEFAULT (''),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[Price] [float] NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_PriceD] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_DescriptionIs] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemSharedVendor_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ItemSharedVendor] ON [Items].[t_ItemSharedVendor]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN

    UPDATE  Items.t_ItemSharedVendor
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_ItemSharedVendor.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'itemSharedVendor'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'itemSharedVendor'
    FROM    Inserted AS s;

  END;

  BEGIN --Live Item

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Items].[t_ItemSharedVendor] ADD CONSTRAINT [PK_t_ItemSharedVendor] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemSharedVendor] ADD CONSTRAINT [ItemSharedKeyItemSharedVendor] FOREIGN KEY ([SharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
