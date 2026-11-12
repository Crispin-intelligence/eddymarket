CREATE TABLE [Location].[t_Region]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Region_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Region_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Region_DescriptionIs] DEFAULT (''),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Region_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Region_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[AddressC] [int] NOT NULL CONSTRAINT [DF_t_Region_AddressC] DEFAULT ((0)),
[BankC] [int] NOT NULL CONSTRAINT [DF_t_Region_BankC] DEFAULT ((0)),
[ContactC] [int] NOT NULL CONSTRAINT [DF_t_Region_ContactC] DEFAULT ((0)),
[CustomerC] [int] NOT NULL CONSTRAINT [DF_t_Region_CustomerC] DEFAULT ((0)),
[EmployeeC] [int] NOT NULL CONSTRAINT [DF_t_Region_EmployeeC] DEFAULT ((0)),
[SalesPersonC] [int] NOT NULL CONSTRAINT [DF_t_Region_SalesPersonC] DEFAULT ((0)),
[VendorC] [int] NOT NULL CONSTRAINT [DF_t_Region_VendorC] DEFAULT ((0)),
[WarehouseC] [int] NOT NULL CONSTRAINT [DF_t_Region_WarehouseC] DEFAULT ((0)),
[StreetC] [int] NOT NULL CONSTRAINT [DF_t_Region_StreetC] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Region_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Region_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Region_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Region_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Location].[tr_Region] ON [Location].[t_Region]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Location.t_Region
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Region.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'region'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'region'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Region, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaLocation, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Location].[t_Region] ADD CONSTRAINT [PK_t_Region] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Region_Name] ON [Location].[t_Region] ([Name], [StatesID]) ON [PRIMARY]
GO
ALTER TABLE [Location].[t_Region] ADD CONSTRAINT [StatesKeyRegion] FOREIGN KEY ([StatesID]) REFERENCES [Location].[t_States] ([ID])
GO
