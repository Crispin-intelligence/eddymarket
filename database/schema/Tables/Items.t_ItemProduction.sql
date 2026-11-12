CREATE TABLE [Items].[t_ItemProduction]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemProduction_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_ItemProduction_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_RefPaper] DEFAULT (''),
[SoldID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemProduction_SoldID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[SoldRef] [bigint] NOT NULL CONSTRAINT [DF_t_ItemProduction_SoldRef] DEFAULT ((0)),
[SoldRefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_SoldRefF] DEFAULT (''),
[SoldDetailID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemProduction_SoldDetailID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_ItemProduction_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_ItemProduction_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_ItemProduction_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_ItemProduction_DateYearly] DEFAULT (getdate()),
[EmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemProduction_EmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[Employee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_Employee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_ItemProduction_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_QtyWithUnity] DEFAULT ('0'),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_ItemProduction_Qtys] DEFAULT ((0)),
[WarehouseID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemProduction_WarehouseID] DEFAULT ([Company].[f_WareHouseGetFirstID]()),
[Warehouse] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_Warehouse] DEFAULT ([Company].[f_WareHouseGetFirstName]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemProduction_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemProduction_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemProduction_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemProduction_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_ItemProduction_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_ItemProduction_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_ItemProduction_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemProduction_CostEuro] DEFAULT ((0)),
[TotalCost] [float] NOT NULL,
[TotalCostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_TotalCostF] DEFAULT ('0'),
[TotalCostD] [float] NOT NULL CONSTRAINT [DF_t_ItemProduction_TotalCostD] DEFAULT ((0)),
[TotalCostLL] [float] NOT NULL CONSTRAINT [DF_t_ItemProduction_TotalCostLL] DEFAULT ((0)),
[TotalCostEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemProduction_TotalCostEuro] DEFAULT ((0)),
[ItemsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_ItemsNames] DEFAULT (''),
[ItemsCounts] [int] NOT NULL CONSTRAINT [DF_t_ItemProduction_ItemsCounts] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ItemProduction_DateCreate] DEFAULT (getdate()),
[CreateByID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemProduction_CreateByID] DEFAULT ([Users].[f_UserGetFirstID]()),
[CreateBy] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemProduction_CreateBy] DEFAULT ([Users].[f_UserGetFirstName]()),
[HaveSerial] [bit] NOT NULL CONSTRAINT [DF_t_ItemProduction_HaveSerial] DEFAULT ((0)),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_ItemProduction_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemProduction_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ItemProduction] ON [Items].[t_ItemProduction]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_ItemProduction
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_ItemProduction.ID );

  END;
 
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'itemProduction'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'itemProduction'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, ItemProduction, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Items].[t_ItemProduction] ADD CONSTRAINT [PK_t_ItemProduction] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemProduction] ADD CONSTRAINT [CurrencyKeyItemProduction] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Items].[t_ItemProduction] ADD CONSTRAINT [ItemKeyItemProduction] FOREIGN KEY ([ItemID]) REFERENCES [Items].[t_Item] ([ID])
GO
ALTER TABLE [Items].[t_ItemProduction] ADD CONSTRAINT [ItemSharedKeyItemProduction] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Items].[t_ItemProduction] ADD CONSTRAINT [UnityItemKeyItemProduction] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
ALTER TABLE [Items].[t_ItemProduction] ADD CONSTRAINT [UserCreateByKeyItemProduction] FOREIGN KEY ([CreateByID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Items].[t_ItemProduction] ADD CONSTRAINT [WareHouseKeyItemProduction] FOREIGN KEY ([WarehouseID]) REFERENCES [Company].[t_WareHouse] ([ID])
GO
