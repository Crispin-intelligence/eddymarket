CREATE TABLE [Company].[t_SocialMediaType]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SocialMediaType_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SocialMediaType_Name] DEFAULT ('Gmail'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SocialMediaType_DescriptionIs] DEFAULT (''),
[SocialMediaC] [bigint] NOT NULL CONSTRAINT [DF_t_SocialMediaType_SocialMediaC] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SocialMediaType_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SocialMediaType_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SocialMediaType_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SocialMediaType_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_SocialMediaType] ON [Company].[t_SocialMediaType]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_SocialMediaType
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_SocialMediaType.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'socialMediaType'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'socialMediaType'
    FROM    Inserted AS s;

  END;
   
  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, SocialMediaType, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));
			
  END;

END;
GO
ALTER TABLE [Company].[t_SocialMediaType] ADD CONSTRAINT [PK_t_SocialMediaType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_SocialMediaType_Name] ON [Company].[t_SocialMediaType] ([Name]) ON [PRIMARY]
GO
