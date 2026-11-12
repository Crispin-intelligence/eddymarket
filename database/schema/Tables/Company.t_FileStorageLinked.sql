CREATE TABLE [Company].[t_FileStorageLinked]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FileStorageLinked_ID] DEFAULT (newsequentialid()),
[OwnerID] [uniqueidentifier] NOT NULL,
[SectionID] [int] NOT NULL CONSTRAINT [DF_t_FileStorageLinked_SectionID] DEFAULT ((0)),
[FileStorageID] [uniqueidentifier] NOT NULL,
[FileStorage] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FileStorageLinked_FileStorage] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_FileStorageLinked_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_FileStorageLinked_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [Company].[tr_FileStorageLinked]
ON [Company].[t_FileStorageLinked]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, FileStorage, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Company].[t_FileStorageLinked] ADD CONSTRAINT [PK_t_FileStorageLinked] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_FileStorageLinked_FileStorage_SectionID_OwnerID] ON [Company].[t_FileStorageLinked] ([FileStorageID], [SectionID], [OwnerID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_FileStorageLinked] ADD CONSTRAINT [FileStorageKeyFileStorageLinked] FOREIGN KEY ([FileStorageID]) REFERENCES [Company].[t_FileStorage] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item = 10
Customer = 15
Employee = 33
Vendor = 67
Sales Person = 149', 'SCHEMA', N'Company', 'TABLE', N't_FileStorageLinked', 'COLUMN', N'SectionID'
GO
