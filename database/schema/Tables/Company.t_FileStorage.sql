CREATE TABLE [Company].[t_FileStorage]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FileStorage_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FileStorage_Name] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FileStorage_Description] DEFAULT (''),
[FileContent] [varbinary] (max) NULL,
[TypeIsID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FileStorage_TypeIsID] DEFAULT ([Company].[f_FileStorageTypeGetFirstID]()),
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FileStorage_TypeIs] DEFAULT ([Company].[f_FileStorageTypeGetFirstName]()),
[FileExtension] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FileStorage_TypeFile] DEFAULT (''),
[FileNameIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FileStorage_NameFile] DEFAULT (''),
[Size] [decimal] (38, 7) NOT NULL CONSTRAINT [DF_t_FileStorage_Size] DEFAULT ((0)),
[SizeF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FileStorage_SizeF] DEFAULT (''),
[ExpirationDate] [date] NOT NULL CONSTRAINT [DF_t_FileStorage_ExpirationDate] DEFAULT (getdate()),
[StopNotification] [bit] NOT NULL CONSTRAINT [DF_t_FileStorage_StopNotification] DEFAULT ((0)),
[NotificationAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FileStorage_NotificationAR] DEFAULT (''),
[NotificationEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_FileStorage_NotificationEN] DEFAULT (''),
[LinkC] [bigint] NOT NULL CONSTRAINT [DF_t_FileStorage_LinkC] DEFAULT ((0)),
[LinkItemC] [bigint] NOT NULL CONSTRAINT [DF_t_FileStorage_LinkItemC] DEFAULT ((0)),
[LinkCustomerC] [bigint] NOT NULL CONSTRAINT [DF_t_FileStorage_LinkCustomerC] DEFAULT ((0)),
[LinkEmployeeC] [bigint] NOT NULL CONSTRAINT [DF_t_FileStorage_LinkEmployeeC] DEFAULT ((0)),
[LinkVendorC] [bigint] NOT NULL CONSTRAINT [DF_t_FileStorage_LinkVendorC] DEFAULT ((0)),
[LinkSalesPersonC] [bigint] NOT NULL CONSTRAINT [DF_t_FileStorage_LinkSalesPersonC] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_FileStorage_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_FileStorage_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_FileStorage]
ON [Company].[t_FileStorage]
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
ALTER TABLE [Company].[t_FileStorage] ADD CONSTRAINT [PK_t_FileStorage] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_FileStorage_Name] ON [Company].[t_FileStorage] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_FileStorage] ADD CONSTRAINT [FileStorageTypeKeyFileStorage] FOREIGN KEY ([TypeIsID]) REFERENCES [Company].[t_FileStorageType] ([ID])
GO
