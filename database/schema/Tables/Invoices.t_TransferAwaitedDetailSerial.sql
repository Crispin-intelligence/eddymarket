CREATE TABLE [Invoices].[t_TransferAwaitedDetailSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransferAwaitedDetailSerial_ID] DEFAULT (newsequentialid()),
[TransferAwaitedID] [uniqueidentifier] NOT NULL,
[TransferAwaitedDetailID] [uniqueidentifier] NOT NULL,
[SerialID] [uniqueidentifier] NOT NULL,
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_TransferAwaitedDetailSerial_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_TransferAwaitedDetailSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_TransferAwaitedDetailSerial] ADD CONSTRAINT [PK_t_TransferAwaitedDetailSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_TransferAwaitedDetailSerial] ADD CONSTRAINT [ItemSerialKeyTransferAwaitedDetailSerial] FOREIGN KEY ([SerialID]) REFERENCES [Items].[t_ItemSerial] ([ID])
GO
ALTER TABLE [Invoices].[t_TransferAwaitedDetailSerial] ADD CONSTRAINT [TransferAwaitedDetailKeyTransferAwaitedDetailSerial] FOREIGN KEY ([TransferAwaitedDetailID]) REFERENCES [Invoices].[t_TransferAwaitedDetail] ([ID])
GO
ALTER TABLE [Invoices].[t_TransferAwaitedDetailSerial] ADD CONSTRAINT [TransferAwaitedKeyTransferAwaitedDetailSerial] FOREIGN KEY ([TransferAwaitedID]) REFERENCES [Invoices].[t_TransferAwaited] ([ID])
GO
