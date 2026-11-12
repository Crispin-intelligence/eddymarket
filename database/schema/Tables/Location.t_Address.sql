CREATE TABLE [Location].[t_Address]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Address_ID] DEFAULT (newsequentialid()),
[SectionID] [int] NOT NULL,
[OwnerID] [uniqueidentifier] NOT NULL,
[OwnerName] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Address_OwnerName] DEFAULT (''),
[Name] [nvarchar] (150) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Address_Name] DEFAULT (''),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Address_TypeIs] DEFAULT ((0)),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Address_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Address_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[RegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Address_RegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[RegionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Address_RegionIs] DEFAULT ([Location].[f_RegionGetFirstName]()),
[StreetID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Address_StreetID] DEFAULT ([Location].[f_StreetGetFirstID]()),
[Street] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Address_Street] DEFAULT ([Location].[f_StreetGetFirstName]()),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Address_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Address_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[FloorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Address_FloorID] DEFAULT ([Location].[f_FloorGetFirstID]()),
[FloorIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Address_FloorIs] DEFAULT ([Location].[f_FloorGetFirstName]()),
[PostalCodeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Address_PostalCodeID] DEFAULT ([Location].[f_PostalCodeGetFirstID]()),
[PostalCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Address_PostalCode] DEFAULT ([Location].[f_PostalCodeGetFirstName]()),
[AddressNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Address_AddressNote] DEFAULT (''),
[AddressIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Address_AddressIs] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Address_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Address_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Address_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Address_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [Location].[tr_Address] ON [Location].[t_Address]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Location.t_Address
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Address.ID );

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'address'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'address'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Addresses, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaLocation, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;

GO
ALTER TABLE [Location].[t_Address] ADD CONSTRAINT [PK_t_Address] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Address_SectionID_OwnerID_Name] ON [Location].[t_Address] ([SectionID], [OwnerID], [Name]) ON [PRIMARY]
GO
ALTER TABLE [Location].[t_Address] ADD CONSTRAINT [BuildingKeyAddress] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Location].[t_Address] ADD CONSTRAINT [FloorKeyAddress] FOREIGN KEY ([FloorID]) REFERENCES [Location].[t_Floor] ([ID])
GO
ALTER TABLE [Location].[t_Address] ADD CONSTRAINT [PostalCodeKeyAddress] FOREIGN KEY ([PostalCodeID]) REFERENCES [Location].[t_PostalCode] ([ID])
GO
ALTER TABLE [Location].[t_Address] ADD CONSTRAINT [RegionkeyAddress] FOREIGN KEY ([RegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Location].[t_Address] ADD CONSTRAINT [StatesKeyAddress] FOREIGN KEY ([StatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Location].[t_Address] ADD CONSTRAINT [StreetKeyAddress] FOREIGN KEY ([StreetID]) REFERENCES [Location].[t_Street] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer = 15
Employee = 33
Bank = 38
Warehouse = 42
Vendor = 67
Sales Person = 149', 'SCHEMA', N'Location', 'TABLE', N't_Address', 'COLUMN', N'SectionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'House = 0
Shop = 1
Street = 2
Another = 3', 'SCHEMA', N'Location', 'TABLE', N't_Address', 'COLUMN', N'TypeIs'
GO
