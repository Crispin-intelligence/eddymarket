CREATE TABLE [Invoices].[t_PurchasingReturnDetailSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingReturnDetailSerial_ID] DEFAULT (newsequentialid()),
[PurchasingReturnID] [uniqueidentifier] NOT NULL,
[PurchasingReturnDetailID] [uniqueidentifier] NOT NULL,
[SerialID] [uniqueidentifier] NOT NULL,
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_PurchasingReturnDetailSerial_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_PurchasingReturnDetailSerial_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_PurchasingReturnDetailSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [Invoices].[tr_PurchasingReturnDetailSerial] ON [Invoices].[t_PurchasingReturnDetailSerial]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_PurchasingReturnDetailSerial
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_PurchasingReturnDetailSerial.ID );

  END;
 
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'purchasingReturnDetailSerial'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'purchasingReturnDetailSerial'
    FROM    Inserted AS s;

  END;
	
END;

GO
ALTER TABLE [Invoices].[t_PurchasingReturnDetailSerial] ADD CONSTRAINT [PK_t_PurchasingReturnDetailSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_PurchasingReturnDetailSerial] ADD CONSTRAINT [ItemSerialKeyPurchasingReturnDetailSerial] FOREIGN KEY ([SerialID]) REFERENCES [Items].[t_ItemSerial] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingReturnDetailSerial] ADD CONSTRAINT [PurchasingReturnDetailKeyPurchasingReturnDetailSerial] FOREIGN KEY ([PurchasingReturnDetailID]) REFERENCES [Invoices].[t_PurchasingReturnDetail] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingReturnDetailSerial] ADD CONSTRAINT [PurchasingReturnKeyPurchasingReturnDetailSerial] FOREIGN KEY ([PurchasingReturnID]) REFERENCES [Invoices].[t_PurchasingReturn] ([ID])
GO
