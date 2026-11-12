CREATE TABLE [Items].[t_ItemSharedBarCode]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSharedBarCode_ID] DEFAULT (newsequentialid()),
[SharedID] [uniqueidentifier] NOT NULL,
[BarCode] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[BarcodeNumber] [bigint] NOT NULL CONSTRAINT [DF_t_ItemSharedBarCode_BarcodeNumber] DEFAULT ((0)),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_ItemSharedBarCode_TypeIs] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ItemSharedBarCode_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_ItemSharedBarCode_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemSharedBarCode_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ItemSharedBarCode] ON [Items].[t_ItemSharedBarCode]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN
  
    BEGIN --Fix

      UPDATE  Items.t_ItemSharedBarCode
      SET     IsSync = 0
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   Inserted AS s
                       WHERE  s.ID = t_ItemSharedBarCode.ID );

    END;

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'itemSharedBarCode'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'itemSharedBarCode'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Items].[t_ItemSharedBarCode] ADD CONSTRAINT [c_BarCodeText] CHECK (([BarCode]<>''))
GO
ALTER TABLE [Items].[t_ItemSharedBarCode] ADD CONSTRAINT [PK_t_ItemSharedBarCode] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [iu_BarCodeText] ON [Items].[t_ItemSharedBarCode] ([BarCode]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemSharedBarCode] ADD CONSTRAINT [ItemSharedKeyItemSharedBarCode] FOREIGN KEY ([SharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Master = 0
Extra = 1
Unity = 2
ItemExpirationDate = 3', 'SCHEMA', N'Items', 'TABLE', N't_ItemSharedBarCode', 'COLUMN', N'TypeIs'
GO
