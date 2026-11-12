CREATE TABLE [Items].[t_ItemProductionMaterial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_ID] DEFAULT (newsequentialid()),
[ItemProductionID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_QtyWithUnity] DEFAULT ('0'),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_Qtys] DEFAULT ((0)),
[WarehouseID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_WarehouseID] DEFAULT ([Company].[f_WareHouseGetFirstID]()),
[Warehouse] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_Warehouse] DEFAULT ([Company].[f_WareHouseGetFirstName]()),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_CostEuro] DEFAULT ((0)),
[TotalCost] [float] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_TotalCost] DEFAULT ((0)),
[TotalCostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_TotalCostF] DEFAULT ('0'),
[TotalCostD] [float] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_TotalCostD] DEFAULT ((0)),
[TotalCostLL] [float] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_TotalCostLL] DEFAULT ((0)),
[TotalCostEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_TotalCostEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemProductionMaterial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ItemProductionMaterial] ON [Items].[t_ItemProductionMaterial]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_ItemProductionMaterial
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_ItemProductionMaterial.ID );

  END;
 
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'itemProductionMaterial'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'itemProductionMaterial'
    FROM    Inserted AS s;

  END;

END;
GO
ALTER TABLE [Items].[t_ItemProductionMaterial] ADD CONSTRAINT [PK_t_ItemProductionMaterial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemProductionMaterial] ADD CONSTRAINT [ItemKeyItemProductionMaterial] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Items].[t_ItemProductionMaterial] ADD CONSTRAINT [ItemProductionKeyItemProductionMaterial] FOREIGN KEY ([ItemProductionID]) REFERENCES [Items].[t_ItemProduction] ([ID])
GO
ALTER TABLE [Items].[t_ItemProductionMaterial] ADD CONSTRAINT [ItemSharedKeyItemProductionMaterial] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Items].[t_ItemProductionMaterial] ADD CONSTRAINT [UnityItemKeyItemProductionMaterial] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
ALTER TABLE [Items].[t_ItemProductionMaterial] ADD CONSTRAINT [WareHouseKeyItemProductionMaterial] FOREIGN KEY ([WarehouseID]) REFERENCES [Company].[t_WareHouse] ([ID])
GO
