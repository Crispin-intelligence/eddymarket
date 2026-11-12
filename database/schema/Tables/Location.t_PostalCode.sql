CREATE TABLE [Location].[t_PostalCode]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PostalCode_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PostalCode_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PostalCode_DescriptionIs] DEFAULT ('-'),
[AddressC] [int] NOT NULL CONSTRAINT [DF_t_PostalCode_AddressC] DEFAULT ((0)),
[BankC] [int] NOT NULL CONSTRAINT [DF_t_PostalCode_BankC] DEFAULT ((0)),
[ContactC] [int] NOT NULL CONSTRAINT [DF_t_PostalCode_ContactC] DEFAULT ((0)),
[CustomerC] [int] NOT NULL CONSTRAINT [DF_t_PostalCode_CustomerC] DEFAULT ((0)),
[EmployeeC] [int] NOT NULL CONSTRAINT [DF_t_PostalCode_EmployeeC] DEFAULT ((0)),
[SalesPersonC] [int] NOT NULL CONSTRAINT [DF_t_PostalCode_SalesPersonC] DEFAULT ((0)),
[VendorC] [int] NOT NULL CONSTRAINT [DF_t_PostalCode_VendorC] DEFAULT ((0)),
[WarehouseC] [int] NOT NULL CONSTRAINT [DF_t_PostalCode_WarehouseC] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PostalCode_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_PostalCode_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_PostalCode_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_PostalCode_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Location].[tr_PostalCode] ON [Location].[t_PostalCode]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Location.t_PostalCode
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_PostalCode.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'postalCode'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'postalCode'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, PostalCode, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaLocation, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Location].[t_PostalCode] ADD CONSTRAINT [PK_t_PostalCode_1] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
