CREATE TABLE [Location].[t_Floor]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Floor_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Floor_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Floor_DescriptionIs] DEFAULT (''),
[AddressC] [int] NOT NULL CONSTRAINT [DF_t_Floor_AddressC] DEFAULT ((0)),
[BankC] [int] NOT NULL CONSTRAINT [DF_t_Floor_BankC] DEFAULT ((0)),
[ContactC] [int] NOT NULL CONSTRAINT [DF_t_Floor_ContactC] DEFAULT ((0)),
[CustomerC] [int] NOT NULL CONSTRAINT [DF_t_Floor_CustomerC] DEFAULT ((0)),
[EmployeeC] [int] NOT NULL CONSTRAINT [DF_t_Floor_EmployeeC] DEFAULT ((0)),
[SalesPersonC] [int] NOT NULL CONSTRAINT [DF_t_Floor_SalesPersonC] DEFAULT ((0)),
[VendorC] [int] NOT NULL CONSTRAINT [DF_t_Floor_VendorC] DEFAULT ((0)),
[WarehouseC] [int] NOT NULL CONSTRAINT [DF_t_Floor_WarehouseC] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Floor_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Floor_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Floor_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Floor_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Location].[tr_Floor] ON [Location].[t_Floor]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Location.t_Floor
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Floor.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'floor'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'floor'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, FloorIs, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaLocation, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Location].[t_Floor] ADD CONSTRAINT [PK_t_Floor] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Floor_Name] ON [Location].[t_Floor] ([Name]) ON [PRIMARY]
GO
