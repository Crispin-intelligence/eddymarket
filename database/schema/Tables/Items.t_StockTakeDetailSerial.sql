CREATE TABLE [Items].[t_StockTakeDetailSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_StockTakeDetailSerial_ID] DEFAULT (newsequentialid()),
[StockTakeID] [uniqueidentifier] NOT NULL,
[StockTakeDetailID] [uniqueidentifier] NOT NULL,
[SerialID] [uniqueidentifier] NOT NULL,
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_StockTakeDetailSerial_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_StockTakeDetailSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_StockTakeDetailSerial] ADD CONSTRAINT [PK_t_StockTakeDetailSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_StockTakeDetailSerial] ADD CONSTRAINT [ItemSerialKeyStockTakeDetailSerial] FOREIGN KEY ([SerialID]) REFERENCES [Items].[t_ItemSerial] ([ID])
GO
ALTER TABLE [Items].[t_StockTakeDetailSerial] ADD CONSTRAINT [StockTakeDetailKeyStockTakeDetailSerial] FOREIGN KEY ([StockTakeDetailID]) REFERENCES [Items].[t_StockTakeDetail] ([ID])
GO
ALTER TABLE [Items].[t_StockTakeDetailSerial] ADD CONSTRAINT [StockTakeKeyStockTakeDetailSerial] FOREIGN KEY ([StockTakeID]) REFERENCES [Items].[t_StockTake] ([ID])
GO
