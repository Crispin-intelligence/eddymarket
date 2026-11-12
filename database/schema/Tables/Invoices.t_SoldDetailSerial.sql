CREATE TABLE [Invoices].[t_SoldDetailSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDetailSerial_ID] DEFAULT (newsequentialid()),
[SoldID] [uniqueidentifier] NOT NULL,
[SoldDetailID] [uniqueidentifier] NOT NULL,
[SerialID] [uniqueidentifier] NOT NULL,
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SoldDetailSerial_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SoldDetailSerial_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SoldDetailSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [Invoices].[tr_SoldDetailSerial] ON [Invoices].[t_SoldDetailSerial]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_SoldDetailSerial
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_SoldDetailSerial.ID );

  END;
 
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'soldDetailSerial'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'soldDetailSerial'
    FROM    Inserted AS s;

  END;
	
END;

GO
ALTER TABLE [Invoices].[t_SoldDetailSerial] ADD CONSTRAINT [PK_t_SoldDetailSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_SoldDetailSerial] ADD CONSTRAINT [ItemSerialKeySoldDetailSerial] FOREIGN KEY ([SerialID]) REFERENCES [Items].[t_ItemSerial] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDetailSerial] ADD CONSTRAINT [SoldDetailKeySoldDetailSerial] FOREIGN KEY ([SoldDetailID]) REFERENCES [Invoices].[t_SoldDetail] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDetailSerial] ADD CONSTRAINT [SoldKeySoldDetailSerial] FOREIGN KEY ([SoldID]) REFERENCES [Invoices].[t_Sold] ([ID])
GO
