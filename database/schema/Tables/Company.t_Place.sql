CREATE TABLE [Company].[t_Place]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Place_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Place_Name] DEFAULT ('-'),
[WareHouseID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Place_WareHouseID] DEFAULT ([Company].[f_WareHouseGetFirstID]()),
[WareHouse] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Place_WareHouse] DEFAULT ([Company].[f_WareHouseGetFirstName]()),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Place_DescriptionIs] DEFAULT (''),
[ItemC] [int] NOT NULL CONSTRAINT [DF_t_Place_ItemC] DEFAULT ((0)),
[Qtys] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Place_Qtys] DEFAULT ((0)),
[Purchase] [float] NOT NULL CONSTRAINT [DF_t_Place_Purchase] DEFAULT ((0)),
[PurchaseF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Place_PurchaseF] DEFAULT ('0'),
[Sell] [float] NOT NULL CONSTRAINT [DF_t_Place_Sell] DEFAULT ((0)),
[SellF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Place_SellF] DEFAULT ('0'),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Place_SearchText] DEFAULT (''),
[DateCreate] [date] NOT NULL CONSTRAINT [DF_t_Place_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Place_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Place_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_Place] ON [Company].[t_Place]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_Place
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Place.ID );

  END;

  BEGIN --Fix data

    UPDATE  Company.t_Place
    SET     SearchText = Company.f_PlaceSearchTextGet(ID)
    WHERE   ID IN ( SELECT  s.ID
                    FROM    Inserted AS s );
  
  END;

  BEGIN --Fix data warehouse

    UPDATE  Company.t_WareHouse
    SET     PlaceC = ( SELECT COUNT(*)
                       FROM   Company.t_Place AS s
                       WHERE  s.WareHouseID = t_WareHouse.ID
                     )
    WHERE   ID IN ( SELECT DISTINCT
                            s.WareHouseID
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
            'place'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'place'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, WarehousePlace, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_Place] ADD CONSTRAINT [PK_t_Place] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Place_Name_WarehouseID] ON [Company].[t_Place] ([Name], [WareHouseID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_Place] ADD CONSTRAINT [WareHouseKeyPlace] FOREIGN KEY ([WareHouseID]) REFERENCES [Company].[t_WareHouse] ([ID])
GO
