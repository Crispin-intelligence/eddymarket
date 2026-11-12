CREATE TABLE [Invoices].[t_SoldReturnDetailSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldReturnDetailSerial_ID] DEFAULT (newsequentialid()),
[SoldReturnID] [uniqueidentifier] NOT NULL,
[SoldReturnDetailID] [uniqueidentifier] NOT NULL,
[SerialID] [uniqueidentifier] NOT NULL,
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SoldReturnDetailSerial_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SoldReturnDetailSerial_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SoldReturnDetailSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_SoldReturnDetailSerial] ON [Invoices].[t_SoldReturnDetailSerial]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_SoldReturnDetailSerial
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_SoldReturnDetailSerial.ID );

  END;
 
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'soldReturnDetailSerial'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'soldReturnDetailSerial'
    FROM    Inserted AS s;

  END;
	
END;


GO
ALTER TABLE [Invoices].[t_SoldReturnDetailSerial] ADD CONSTRAINT [PK_t_SoldReturnDetailSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_SoldReturnDetailSerial] ADD CONSTRAINT [ItemSerialKeySoldReturnDetailSerial] FOREIGN KEY ([SerialID]) REFERENCES [Items].[t_ItemSerial] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturnDetailSerial] ADD CONSTRAINT [SoldReturnDetailKeySoldReturnDetailSerial] FOREIGN KEY ([SoldReturnDetailID]) REFERENCES [Invoices].[t_SoldReturnDetail] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldReturnDetailSerial] ADD CONSTRAINT [SoldReturnKeySoldReturnDetailSerial] FOREIGN KEY ([SoldReturnID]) REFERENCES [Invoices].[t_SoldReturn] ([ID])
GO
