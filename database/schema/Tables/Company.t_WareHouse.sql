CREATE TABLE [Company].[t_WareHouse]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WareHouse_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_Name] DEFAULT ('On Hand'),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WareHouse_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[Phones] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_Phones] DEFAULT (''),
[SocialMedia] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_SocialMedia] DEFAULT (''),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WareHouse_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[RegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WareHouse_RegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[RegionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_RegionIs] DEFAULT ([Location].[f_RegionGetFirstName]()),
[StreetID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WareHouse_StreetID] DEFAULT ([Location].[f_StreetGetFirstID]()),
[Street] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_Street] DEFAULT ([Location].[f_StreetGetFirstName]()),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WareHouse_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[FloorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WareHouse_FloorID] DEFAULT ([Location].[f_FloorGetFirstID]()),
[FloorIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_FloorIs] DEFAULT ([Location].[f_FloorGetFirstName]()),
[PostalCodeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WareHouse_PostalCodeID] DEFAULT ([Location].[f_PostalCodeGetFirstID]()),
[PostalCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_PostalCode] DEFAULT ([Location].[f_PostalCodeGetFirstName]()),
[AddressNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_AddressNote] DEFAULT (''),
[AddressIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_AddressIs] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_DescriptionIs] DEFAULT (''),
[PhonesC] [int] NOT NULL CONSTRAINT [DF_t_WareHouse_PhonesC] DEFAULT ((0)),
[SocialMediaC] [int] NOT NULL CONSTRAINT [DF_t_WareHouse_SocialMediaC] DEFAULT ((0)),
[PlaceC] [int] NOT NULL CONSTRAINT [DF_t_WareHouse_PlaceC] DEFAULT ((0)),
[UserC] [int] NOT NULL CONSTRAINT [DF_t_WareHouse_UserC] DEFAULT ((0)),
[ItemC] [int] NOT NULL CONSTRAINT [DF_t_WareHouse_ItemC] DEFAULT ((0)),
[Qtys] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_WareHouse_Qtys] DEFAULT ((0.0)),
[Purchase] [float] NOT NULL CONSTRAINT [DF_t_WareHouse_Purchase] DEFAULT ((0)),
[PurchaseF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_PurchaseF] DEFAULT (''),
[Sell] [float] NOT NULL CONSTRAINT [DF_t_WareHouse_Sell] DEFAULT ((0)),
[SellF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_SellF] DEFAULT (''),
[UsersNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_UsersNames] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WareHouse_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_WareHouse_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_WareHouse_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_WareHouse_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_WareHouse] ON [Company].[t_WareHouse]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_WareHouse
    SET     SearchText = Company.f_WareHouseSearchTextGet(ID)
    WHERE   ID IN ( SELECT  s.ID
                    FROM    Inserted AS s );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'wareHouse'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'wareHouse'
    FROM    Inserted AS s;

  END;
   
  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Warehouse, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_WareHouse] ADD CONSTRAINT [PK_t_WareHouse_1] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_t_WareHouse_Name] ON [Company].[t_WareHouse] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_WareHouse] ADD CONSTRAINT [BuildingKeyWareHouse] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Company].[t_WareHouse] ADD CONSTRAINT [FloorKeyWareHouse] FOREIGN KEY ([FloorID]) REFERENCES [Location].[t_Floor] ([ID])
GO
ALTER TABLE [Company].[t_WareHouse] ADD CONSTRAINT [PostalCodeKeyWareHouse] FOREIGN KEY ([PostalCodeID]) REFERENCES [Location].[t_PostalCode] ([ID])
GO
ALTER TABLE [Company].[t_WareHouse] ADD CONSTRAINT [RegionkeyWareHouse] FOREIGN KEY ([RegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Company].[t_WareHouse] ADD CONSTRAINT [StatesKeyWareHouse] FOREIGN KEY ([StatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Company].[t_WareHouse] ADD CONSTRAINT [StreetKeyWareHouse] FOREIGN KEY ([StreetID]) REFERENCES [Location].[t_Street] ([ID])
GO
ALTER TABLE [Company].[t_WareHouse] ADD CONSTRAINT [UserKeyWareHouse] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
