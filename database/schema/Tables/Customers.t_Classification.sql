CREATE TABLE [Customers].[t_Classification]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Classification_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Classification_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Classification_DescriptionIs] DEFAULT (''),
[CustomerC] [int] NOT NULL CONSTRAINT [DF_t_Classification_CustomerC] DEFAULT ((0)),
[VendorC] [int] NOT NULL CONSTRAINT [DF_t_Classification_VendorC] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Classification_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Classification_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Classification_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Classification_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Customers].[tr_Classification] ON [Customers].[t_Classification]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Customers.t_Classification
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Classification.ID );


  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'classification'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'classification'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Classification, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCustomer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Customers].[t_Classification] ADD CONSTRAINT [PK_t_Classification] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Customers].[t_Classification] ADD CONSTRAINT [ui_t_Classification_Name] UNIQUE NONCLUSTERED  ([Name]) WITH (ALLOW_ROW_LOCKS=OFF, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
