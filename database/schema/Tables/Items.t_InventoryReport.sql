CREATE TABLE [Items].[t_InventoryReport]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InventoryReport_ID] DEFAULT (newsequentialid()),
[SharedID] [int] NOT NULL,
[Qty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_InventoryReport_Qty] DEFAULT ((0.0)),
[Purchase] [float] NOT NULL CONSTRAINT [DF_t_InventoryReport_Purchase] DEFAULT ((0)),
[PurchaseF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InventoryReport_PurchaseF] DEFAULT (''),
[PurchaseTotal] [float] NOT NULL CONSTRAINT [DF_t_InventoryReport_PurchaseTotal] DEFAULT ((0)),
[PurchaseTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InventoryReport_PurchaseTotalF] DEFAULT (''),
[Distributor] [float] NOT NULL CONSTRAINT [DF_t_InventoryReport_Distributor] DEFAULT ((0)),
[DistributorF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InventoryReport_DistributorF] DEFAULT (''),
[DistributorTotal] [float] NOT NULL CONSTRAINT [DF_t_InventoryReport_DistributorTotal] DEFAULT ((0)),
[DistributorTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InventoryReport_DistributorTotalF] DEFAULT (''),
[Wholesale] [float] NOT NULL CONSTRAINT [DF_t_InventoryReport_Wholesale] DEFAULT ((0)),
[WholesaleF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InventoryReport_WholesaleF] DEFAULT (''),
[WholesaleTotal] [float] NOT NULL CONSTRAINT [DF_t_InventoryReport_WholesaleTotal] DEFAULT ((0)),
[WholesaleTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InventoryReport_WholesaleTotalF] DEFAULT (''),
[Sell] [float] NOT NULL CONSTRAINT [DF_t_InventoryReport_Sell] DEFAULT ((0)),
[SellF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InventoryReport_SellF] DEFAULT (''),
[SellTotal] [float] NOT NULL CONSTRAINT [DF_t_InventoryReport_SellTotal] DEFAULT ((0)),
[SellTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InventoryReport_SellTotalF] DEFAULT (''),
[Warehouse] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InventoryReport_Warehouse] DEFAULT (''),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_InventoryReport_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Items].[t_InventoryReport] ADD CONSTRAINT [PK_t_InventoryReport] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
