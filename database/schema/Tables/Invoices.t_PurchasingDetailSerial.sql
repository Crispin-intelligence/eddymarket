CREATE TABLE [Invoices].[t_PurchasingDetailSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PurchasingDetailSerial_ID] DEFAULT (newsequentialid()),
[PurchasingID] [uniqueidentifier] NOT NULL,
[PurchasingDetailID] [uniqueidentifier] NOT NULL,
[SerialID] [uniqueidentifier] NOT NULL,
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_PurchasingDetailSerial_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_PurchasingDetailSerial_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_PurchasingDetailSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_PurchasingDetailSerial] ON [Invoices].[t_PurchasingDetailSerial]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_PurchasingDetailSerial
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_PurchasingDetailSerial.ID );

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'purchasingDetailSerial'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'purchasingDetailSerial'
    FROM    Inserted AS s;

  END;
	
END;
GO
ALTER TABLE [Invoices].[t_PurchasingDetailSerial] ADD CONSTRAINT [PK_t_PurchasingDetailSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_PurchasingDetailSerial] ADD CONSTRAINT [ItemSerialKeyPurchasingDetailSerial] FOREIGN KEY ([SerialID]) REFERENCES [Items].[t_ItemSerial] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingDetailSerial] ADD CONSTRAINT [PurchasingDetailKeyPurchasingDetailSerial] FOREIGN KEY ([PurchasingDetailID]) REFERENCES [Invoices].[t_PurchasingDetail] ([ID])
GO
ALTER TABLE [Invoices].[t_PurchasingDetailSerial] ADD CONSTRAINT [PurchasingKeyPurchasingDetailSerial] FOREIGN KEY ([PurchasingID]) REFERENCES [Invoices].[t_Purchasing] ([ID])
GO
