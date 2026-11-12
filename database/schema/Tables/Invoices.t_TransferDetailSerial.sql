CREATE TABLE [Invoices].[t_TransferDetailSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransferDetailSerial_ID] DEFAULT (newsequentialid()),
[TransferID] [uniqueidentifier] NOT NULL,
[TransferDetailID] [uniqueidentifier] NOT NULL,
[SerialID] [uniqueidentifier] NOT NULL,
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_TransferDetailSerial_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_TransferDetailSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_TransferDetailSerial] ADD CONSTRAINT [PK_t_TransferDetailSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_TransferDetailSerial] ADD CONSTRAINT [ItemSerialKeyTransferDetailSerial] FOREIGN KEY ([SerialID]) REFERENCES [Items].[t_ItemSerial] ([ID])
GO
ALTER TABLE [Invoices].[t_TransferDetailSerial] ADD CONSTRAINT [TransferDetailKeyTransferDetailSerial] FOREIGN KEY ([TransferDetailID]) REFERENCES [Invoices].[t_TransferDetail] ([ID])
GO
ALTER TABLE [Invoices].[t_TransferDetailSerial] ADD CONSTRAINT [TransferKeyTransferDetailSerial] FOREIGN KEY ([TransferID]) REFERENCES [Invoices].[t_Transfer] ([ID])
GO
