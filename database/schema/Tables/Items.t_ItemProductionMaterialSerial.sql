CREATE TABLE [Items].[t_ItemProductionMaterialSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterialSerial_ID] DEFAULT (newsequentialid()),
[ItemProductionID] [uniqueidentifier] NOT NULL,
[ItemProductionMaterialID] [uniqueidentifier] NOT NULL,
[SerialID] [uniqueidentifier] NOT NULL,
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterialSerial_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterialSerial_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterialSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ItemProductionMaterialSerial] ON [Items].[t_ItemProductionMaterialSerial]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_ItemProductionMaterialSerial
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_ItemProductionMaterialSerial.ID );

  END;
 
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'itemProductionMaterialSerial'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'itemProductionMaterialSerial'
    FROM    Inserted AS s;

  END;

END;


GO
ALTER TABLE [Items].[t_ItemProductionMaterialSerial] ADD CONSTRAINT [PK_t_ItemProductionMaterialSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemProductionMaterialSerial] ADD CONSTRAINT [ItemProductionKeyItemProductionMaterialSerial] FOREIGN KEY ([ItemProductionID]) REFERENCES [Items].[t_ItemProduction] ([ID])
GO
ALTER TABLE [Items].[t_ItemProductionMaterialSerial] ADD CONSTRAINT [ItemProductionMaterialKeyItemProductionMaterialSerial] FOREIGN KEY ([ItemProductionMaterialID]) REFERENCES [Items].[t_ItemProductionMaterial] ([ID])
GO
ALTER TABLE [Items].[t_ItemProductionMaterialSerial] ADD CONSTRAINT [ItemSerialKeyItemProductionMaterialSerial] FOREIGN KEY ([SerialID]) REFERENCES [Items].[t_ItemSerial] ([ID])
GO
