CREATE TABLE [Items].[t_ItemProductionSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemProductionSerial_ID] DEFAULT (newsequentialid()),
[ItemProductionID] [uniqueidentifier] NOT NULL,
[SerialID] [uniqueidentifier] NOT NULL,
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ItemProductionSerial_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_ItemProductionSerial_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemProductionSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ItemProductionSerial] ON [Items].[t_ItemProductionSerial]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_ItemProductionSerial
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_ItemProductionSerial.ID );

  END;
 
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'itemProductionSerial'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'itemProductionSerial'
    FROM    Inserted AS s;

  END;

END;

GO
ALTER TABLE [Items].[t_ItemProductionSerial] ADD CONSTRAINT [PK_t_ItemProductionSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemProductionSerial] ADD CONSTRAINT [ItemProductionKeyItemProductionSerial] FOREIGN KEY ([ItemProductionID]) REFERENCES [Items].[t_ItemProduction] ([ID])
GO
ALTER TABLE [Items].[t_ItemProductionSerial] ADD CONSTRAINT [ItemSerialKeyItemProductionSerial] FOREIGN KEY ([SerialID]) REFERENCES [Items].[t_ItemSerial] ([ID])
GO
