CREATE TABLE [Company].[t_WarehouseUser]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WarehouseUser_ID] DEFAULT (newsequentialid()),
[WarehouseID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WarehouseUser_WarehouseID] DEFAULT ([Company].[f_WareHouseGetFirstID]()),
[Warehouse] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WarehouseUser_Warehouse] DEFAULT ([Company].[f_WareHouseGetFirstName]()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WarehouseUser_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WarehouseUser_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WarehouseUser_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_WarehouseUser_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_WarehouseUser_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_WarehouseUser_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_WareHouseUser] ON [Company].[t_WarehouseUser]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_WarehouseUser
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_WarehouseUser.ID );

  END;

  BEGIN --Fix data

    UPDATE  Company.t_WarehouseUser
    SET     SearchText = Company.f_WareHouseUserSearchTextGet(ID)
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
            'warehouseUser'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'warehouseUser'
    FROM    Inserted AS s;

  END;
   
  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Warehouse, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;
	
END;
GO
ALTER TABLE [Company].[t_WarehouseUser] ADD CONSTRAINT [PK_t_WarehouseUser] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_WarehouseUser_WarehouseID_UserID] ON [Company].[t_WarehouseUser] ([WarehouseID], [UserID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_WarehouseUser] ADD CONSTRAINT [UserKeyWarehouseUser] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Company].[t_WarehouseUser] ADD CONSTRAINT [WareHouseKeyWarehouseUser] FOREIGN KEY ([WarehouseID]) REFERENCES [Company].[t_WareHouse] ([ID]) ON DELETE CASCADE
GO
