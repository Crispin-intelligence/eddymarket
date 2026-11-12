CREATE TABLE [Vendors].[t_VendorOption]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_VendorOption_ID] DEFAULT (newsequentialid()),
[ARAdditionalProperty1] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ARAdditionalProperty1] DEFAULT ('خاصية 1'),
[ARAdditionalProperty2] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ARAdditionalProperty2] DEFAULT ('خاصية 2'),
[ARAdditionalProperty3] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ARAdditionalProperty3] DEFAULT ('خاصية 3'),
[ARAdditionalProperty4] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ARAdditionalProperty4] DEFAULT ('خاصية 4'),
[ARAdditionalProperty5] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ARAdditionalProperty5] DEFAULT ('خاصية 5'),
[ARAdditionalProperty6] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ARAdditionalProperty6] DEFAULT ('خاصية 6'),
[ARAdditionalProperty7] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ARAdditionalProperty7] DEFAULT ('خاصية 7'),
[ARAdditionalProperty8] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ARAdditionalProperty8] DEFAULT ('خاصية 8'),
[ARAdditionalProperty9] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ARAdditionalProperty9] DEFAULT ('خاصية 9'),
[ARAdditionalProperty10] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ARAdditionalProperty10] DEFAULT ('خاصية 10'),
[ENAdditionalProperty1] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ENAdditionalProperty1] DEFAULT ('Property 1'),
[ENAdditionalProperty2] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ENAdditionalProperty2] DEFAULT ('Property 2'),
[ENAdditionalProperty3] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ENAdditionalProperty3] DEFAULT ('Property 3'),
[ENAdditionalProperty4] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ENAdditionalProperty4] DEFAULT ('Property 4'),
[ENAdditionalProperty5] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ENAdditionalProperty5] DEFAULT ('Property 5'),
[ENAdditionalProperty6] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ENAdditionalProperty6] DEFAULT ('Property 6'),
[ENAdditionalProperty7] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ENAdditionalProperty7] DEFAULT ('Property 7'),
[ENAdditionalProperty8] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ENAdditionalProperty8] DEFAULT ('Property 8'),
[ENAdditionalProperty9] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ENAdditionalProperty9] DEFAULT ('Property 9'),
[ENAdditionalProperty10] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VendorOption_ENAdditionalProperty10] DEFAULT ('Property 10'),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_VendorOption_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_VendorOption_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Vendors].[tr_VendorOption] ON [Vendors].[t_VendorOption]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Vendors.t_VendorOption
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_VendorOption.ID );

  END;
    
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'vendorOption'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'vendorOption'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Vendor, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaVendor, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));
  END;

END;
GO
ALTER TABLE [Vendors].[t_VendorOption] ADD CONSTRAINT [PK_t_VendorOption] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
