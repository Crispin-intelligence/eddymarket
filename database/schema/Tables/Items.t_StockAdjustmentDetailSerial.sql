CREATE TABLE [Items].[t_StockAdjustmentDetailSerial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetailSerial_ID] DEFAULT (newsequentialid()),
[StockAdjustmentID] [uniqueidentifier] NOT NULL,
[StockAdjustmentDetailID] [uniqueidentifier] NOT NULL,
[SerialID] [uniqueidentifier] NOT NULL,
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetailSerial_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_StockAdjustmentDetailSerial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_StockAdjustmentDetailSerial] ADD CONSTRAINT [PK_t_StockAdjustmentDetailSerial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_StockAdjustmentDetailSerial] ADD CONSTRAINT [ItemSerialKeyStockAdjustmentDetailSerial] FOREIGN KEY ([SerialID]) REFERENCES [Items].[t_ItemSerial] ([ID])
GO
ALTER TABLE [Items].[t_StockAdjustmentDetailSerial] ADD CONSTRAINT [StockAdjustmentDetailKeyStockAdjustmentDetailSerial] FOREIGN KEY ([StockAdjustmentDetailID]) REFERENCES [Items].[t_StockAdjustmentDetail] ([ID])
GO
ALTER TABLE [Items].[t_StockAdjustmentDetailSerial] ADD CONSTRAINT [StockAdjustmentKeyStockAdjustmentDetailSerial] FOREIGN KEY ([StockAdjustmentID]) REFERENCES [Items].[t_StockAdjustment] ([ID])
GO
