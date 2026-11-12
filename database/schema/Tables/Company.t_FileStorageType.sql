CREATE TABLE [Company].[t_FileStorageType]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FileStorageType_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FileStorageTypes_Name] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FileStorageTypes_DescriptionIs] DEFAULT (''),
[FileStorageC] [bigint] NOT NULL CONSTRAINT [DF_t_FileStorageType_FileStorageC] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_FileStorageType_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_FileStorageTypes_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_FileStorageType]
ON [Company].[t_FileStorageType]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, FileStorageTypes, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Company].[t_FileStorageType] ADD CONSTRAINT [PK_t_FileStorageType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
