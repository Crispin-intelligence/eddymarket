CREATE TABLE [Items].[t_BeginningInventoryQuantityDetailSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetailSerial_ID] DEFAULT (newsequentialid()),
[BeginningInventoryQuantityID] [uniqueidentifier] NOT NULL,
[BeginningInventoryQuantityDetailID] [uniqueidentifier] NOT NULL,
[SerialID] [uniqueidentifier] NOT NULL,
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetailSerial_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_BeginningInventoryQuantityDetailSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_BeginningInventoryQuantityDetailSerial] ADD CONSTRAINT [PK_t_BeginningInventoryQuantityDetailSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_BeginningInventoryQuantityDetailSerial] ADD CONSTRAINT [BeginningInventoryQuantityDetailKeyBeginningInventoryQuantityDetailSerial] FOREIGN KEY ([BeginningInventoryQuantityDetailID]) REFERENCES [Items].[t_BeginningInventoryQuantityDetail] ([ID])
GO
ALTER TABLE [Items].[t_BeginningInventoryQuantityDetailSerial] ADD CONSTRAINT [BeginningInventoryQuantityKeyBeginningInventoryQuantityDetailSerial] FOREIGN KEY ([BeginningInventoryQuantityID]) REFERENCES [Items].[t_BeginningInventoryQuantity] ([ID])
GO
ALTER TABLE [Items].[t_BeginningInventoryQuantityDetailSerial] ADD CONSTRAINT [ItemSerialKeyBeginningInventoryQuantityDetailSerial] FOREIGN KEY ([SerialID]) REFERENCES [Items].[t_ItemSerial] ([ID])
GO
