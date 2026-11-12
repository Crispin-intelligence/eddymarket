CREATE TABLE [Invoices].[t_InvoiceTitle]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InvoiceTitle_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InvoiceTitle_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InvoiceTitle_DescriptionIs] DEFAULT (''),
[PurchaseC] [bigint] NOT NULL CONSTRAINT [DF_t_InvoiceTitle_PurchaseC] DEFAULT ((0)),
[PurchaseReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_InvoiceTitle_PurchaseReturnC] DEFAULT ((0)),
[SellC] [bigint] NOT NULL CONSTRAINT [DF_t_InvoiceTitle_SellC] DEFAULT ((0)),
[SellReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_InvoiceTitle_SellReturnC] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InvoiceTitle_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_InvoiceTitle_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_InvoiceTitle_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_InvoiceTitle_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_InvoiceTitle] ON [Invoices].[t_InvoiceTitle]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_InvoiceTitle
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_InvoiceTitle.ID );

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'invoiceTitle'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'invoiceTitle'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, InvoiceTitle, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Invoices].[t_InvoiceTitle] ADD CONSTRAINT [PK_t_InvoiceTitle] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_InvoiceTitle_Name] ON [Invoices].[t_InvoiceTitle] ([Name]) ON [PRIMARY]
GO
